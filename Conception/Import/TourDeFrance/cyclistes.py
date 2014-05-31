# -*-coding:UTF-8 -*

import os
import urllib2
import re
from HTMLParser import HTMLParser

iPays = 1
list_pays = {}
def add_pays (nom_pays):
    global iPays
    global list_pays

    if nom_pays not in list_pays:
        list_pays[nom_pays] = str(iPays)
        res = iPays
        iPays = iPays + 1
    else:
        res = list_pays[nom_pays]

    return res

def get_pays_nom(num_pays):
    global list_pays
    for (key, value) in list_pays.items():
        if(value == str(num_pays)):
            return key

def get_pays_index(nom_pays):
    global list_pays
    return list_pays[nom_pays]

#Parser pour la liste des equipes
class TeamsListHTMLParser(HTMLParser):

    def __init__(self):
        HTMLParser.__init__(self)
        self.tag = ""
        self.type = ""
        self.teams = []
        self.ul = ""
        self.re_manager = re.compile('Directeurs sportifs : ([A-Z -]*) (.*) / ([A-Z -]*) (.*)')


    def handle_starttag(self, tag, attrs):

        if tag == 'a':
            for attr in attrs:
                if 'href' in attr and re.match(r"/le-tour/2013/fr/equipes/.*", attr[1]):
                    self.tag = tag
                    self.type = 'team'

        if tag == 'span':
            if self.type == 'team':
                self.tag = tag
                self.type = 'country'

            for attr in attrs:
                if 'class' in attr and attr[1] == 'manager':
                    self.tag = tag
                    self.type = 'manager'

        if tag == "ul":
             for attr in attrs:
                 if 'class' in attr and attr[1] == 'equipes accordion':
                     self.ul = 'accordion'

        if self.ul == 'accordion' and  tag == 'li':
            for attr in attrs:
                 if 'class' in attr:
                     self.acro = attr[1]

    def handle_endtag(self, tag):
        if self.type == 'end_team':
            re_country= re.search(r"/*(.+)", self.team_country)
            self.num_pays  = add_pays(re_country.group(1))
            self.teams.append({'nom': self.team_nom, 'acro': self.acro, 'pays':self.num_pays, 'managers': self.team_managers})
            self.type = ''

        if self.tag == tag:
            self.tag = ''
            self.type = ''

        if self.ul == 'accordion' and tag == 'ul':
            self.ul = ''


    def handle_data(self, data):
        if self.type == 'team':
            self.team_nom = data
        elif self.type == 'country':
            self.team_country = data
        elif self.type == 'manager':
            m = self.re_manager.search(data);
            self.team_managers = [{'prenom': m.group(2), 'nom': m.group(1)}, {'prenom' : m.group(4), 'nom' : m.group(3)}]
            self.type = 'end_team'


#Parser pour la liste des cyclistes
class RidersListHTMLParser(HTMLParser):

    def __init__(self):
        HTMLParser.__init__(self)
        self.tag = ""
        self.type = ""
        self.riders = []


    def handle_starttag(self, tag, attrs):

        if self.type == 'rider':
            if tag == 'a':
                self.type = 'rider_nom'
                for attr in attrs:
                    if 'href' in attr:
                        self.rider_link = attr[1]

        for attr in attrs:
            if 'class' in attr:
                if attr[1] in ['bib', 'rider']:
                   self.tag = tag
                   self.type = attr[1]

            elif attr[0] == 'href' and re.match(r".*equipes.*", attr[1]):
                self.tag = tag
                self.type = 'team'


    def handle_endtag(self, tag):

        if self.type == 'end_rider':
            m_nom = re.search(r"([A-Z -]+) ([éA-Za-z -]+)", self.rider_nom)
            self.rider_prenom = m_nom.group(2)
            self.rider_nom = m_nom.group(1)
            self.riders.append({'num': self.rider_num, 'nom': self.rider_nom, 'prenom': self.rider_prenom, 'equipe': self.rider_team, 'link': self.rider_link})
            self.type = ''

        if tag == self.tag:
             self.tag = ""
             self.type = ""


    def handle_data(self, data):

        if self.type == 'bib':
            self.rider_num = data
        elif self.type == 'rider_nom':
            self.rider_nom = data
            self.type = 'end_rider'
        elif self.type == 'team':
            self.rider_team = data
            self.type = ''

#Parser pour la page cycliste
class RiderHTMLParser(HTMLParser):

    def __init__(self):
        HTMLParser.__init__(self)
        self.tag = ""
        self.type = ""
        self.classement_etape = []
        self.classement_gene = []

        #si les donnees sont manquantes
        self.poids = 'NULL'
        self.taille = 'NULL'
        self.pays = 'NULL'


    def handle_starttag(self, tag, attrs):
        self.tag = tag
        for attr in attrs:
            if "class" in attr:
                 if attr[1] in ['date', 'country', 'size', 'weight', 'ite', 'itg']:
                     self.type = attr[1]
                 elif attr[1] == 'label' and self.type == 'ite':
                     self.type = 'label_ite'
                 elif attr[1] == 'label' and  self.type == 'itg':
                    self.type = 'label_itg'
                 elif attr[1] == 'fiche':
                     self.type = 'fiche'

        if self.type == 'fiche' and self.tag == 'h2':
            self.type = 'nom_team'


        if self.tag == 'td' and (self.type == 'label_ite' or self.type == 'res_ite'):
            self.type = 'res_ite'

        if self.tag == 'td' and (self.type == 'label_itg' or self.type == 'res_itg'):
            self.type = 'res_itg'


    def handle_endtag(self, tag):
        if tag == self.tag:
            self.tag = ''
        if tag == 'tr' and (self.type == 'res_ite' or self.type == 'res_itg'):
            self.type = ''

    def handle_data(self, data):
        if self.type == 'date':
            self.daten = data
            self.type = ''
        elif self.type == 'country':
            re_pays = re.search(r'\((.*)\)', data)
            if re_pays is not None:
                self.pays = re_pays.group(1)
                self.type = ''
        elif self.type == 'size':
            re_taille = re.search(r'[1-9.]*', data)
            self.taille = str(int(float(re_taille.group(0)) * 100))
            self.type = ''
        elif self.type == 'weight':
            re_poids = re.search(r'[1-9.]*', data)
            self.poids = re_poids.group(0)
            self.type = ''
        elif self.tag == 'td' and self.type == 'res_ite':
           self.classement_etape.append(data)
        elif self.tag == 'td' and self.type == 'res_itg':
           self.classement_gene.append(data)
        elif self.type == 'nom_team':
            self.team = data
            self.type = ''

teams = []
riders = []

#Recuperer la liste de toutes les equipes
response = urllib2.urlopen('http://www.letour.fr/le-tour/2013/fr/equipes/rlt.html')
teams_list_parser = TeamsListHTMLParser()
teams_list_parser.feed(response.read().decode('latin1'))
teams = teams_list_parser.teams

#Recuperer la liste de tous les coureurs
response = urllib2.urlopen('http://www.letour.fr/le-tour/2013/fr/partants.html')
riders_list_parser = RidersListHTMLParser()
riders_list_parser.feed(response.read().decode('latin-1'))

#Recueperer les details pour chacun des coueurs
for rider in riders_list_parser.riders:
    #parse
    response = urllib2.urlopen('http://www.letour.fr' + rider['link'])
    rider_parser = RiderHTMLParser()
    rider_parser.feed(response.read().decode('latin-1'))

    rider['daten'] = rider_parser.daten
    rider['pays'] = rider_parser.pays
    rider['taille'] = rider_parser.taille
    rider['poids'] = rider_parser.poids
    rider['class_etape'] = rider_parser.classement_etape
    rider['class_gene_etape'] = rider_parser.classement_gene
    rider['equipe'] = rider_parser.team

    riders.append(rider)
    print rider

#Now we write in file
file_pays = open('pays.sql', 'w')
file_pays.write('INSERT INTO PAYS(PAYS_NUM, PAYS_NOM) VALUES \n')

for (nom_pays, num_pays) in list_pays.items():
    file_pays.write(("(" +  num_pays + ", '" + nom_pays + "'),\n").encode('utf-8'))


file_directeur_sportif = open('directeur_sportif.sql', 'w')
file_equipe = open('equipe.sql', 'w')
file_diriger = open('diriger.sql', 'w')


file_directeur_sportif.write('INSERT INTO DIRECTEUR_SPORTIF (DIRS_NUM, DIRS_NOM, DIRS_PRENOM) VALUES \n')
file_equipe.write('INSERT INTO EQUIPE (TOUR_ANNEE, EQUIPE_NUM, EQUIPE_NOM, EQUIPE_WEB, EQUIPE_DESC, EQUIPE_PAYS, SPON_NOM, SPON_ACRO, PAYS_NUM) VALUES \n')
file_diriger.write('INSERT INTO DIRIGER (TOUR_ANNEE, EQUIPE_NUM, DIRS_NUM) VALUES \n')
iTeam = 1
iDirecteur = 1
team_label = {}
for team in teams:
    file_directeur_sportif.write(("(" + str(iDirecteur) + ", '" + team['managers'][0]['nom'] + "', '" + team['managers'][0]['prenom'] + "'),\n").encode('utf-8'))
    file_directeur_sportif.write(("(" + str(iDirecteur + 1) +  ", '" + team['managers'][1]['nom'] + "', '" + team['managers'][1]['prenom'] + "'),\n").encode('utf-8'))

    file_equipe.write(("(2013, " + str(iTeam) + ", '" + team['nom'] + "', '" + team['acro'] + ".com', '" + team['nom'] + "', '" + get_pays_nom(team['pays']) + "', '" + team['nom'] + "', '" +  team['acro'] + "' ," + str(team['pays']) + "),\n".encode('utf-8')))

    file_diriger.write(("(2013, " + str(iTeam) +", " + str(iDirecteur) + "),\n").encode('utf-8'))
    file_diriger.write(("(2013, " + str(iTeam) +", " + str(iDirecteur + 1) + "),\n").encode('utf-8'))

    team_label[team['nom'].upper()] = iTeam

    iDirecteur = iDirecteur + 2
    iTeam = iTeam + 1


file_cycliste = open('cycliste.sql', 'w')
file_participant = open('participant.sql', 'w')

file_cycliste.write('INSERT INTO CYCLISTE(CYCLISTE_NUM, CYCLISTE_NOM, CYCLISTE_PRENOM, CYCLISTE_DATEN) VALUES \n')
file_participant.write('INSERT INTO PARTICIPANT(TOUR_ANNEE, PART_NUM, PART_POIDS, PART_TAILLE, EQUIPE_NUM, CYCLISTE_NUM) VALUES \n')
iCycliste = 1
for cycliste in riders:
    file_cycliste.write(("(" + str(iCycliste) + ", '" + cycliste['nom'] + "', '" + cycliste['prenom'] +  "', '" + cycliste['daten'] +  "', %" + cycliste['pays'] + "%),\n").encode('utf-8'))
    file_participant.write(("(2013, " + cycliste['num'] + ", " + cycliste['poids'] +  ", " + cycliste['taille'] + ", " + str(team_label[cycliste['equipe']]) + ", " + str(iCycliste) + "),\n").encode('utf-8'))
    iCycliste = iCycliste + 1

