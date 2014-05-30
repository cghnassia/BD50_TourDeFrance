# -*-coding:UTF-8 -*

from urllib import urlopen
import bs4 as BeautifulSoup
import datetime
import re

debut_tour = datetime.datetime(2013, 6, 29)
repos_1 = 15
repos_2 = 8


table_categories = [
    { 'cat_num' : 1, 'cat_lib': u'Col de catégorie 4', 'maillot_couleur': 'pois'},
    { 'cat_num' : 2, 'cat_lib': u'Col de catégorie 3', 'maillot_couleur': 'pois'},
    { 'cat_num' : 3, 'cat_lib': u'Col de catégorie 2', 'maillot_couleur': 'pois'},
    { 'cat_num' : 4, 'cat_lib': u'Col de catégorie 1', 'maillot_couleur': 'pois'},
    { 'cat_num' : 5, 'cat_lib': u'Col hors catégorie', 'maillot_couleur': 'pois'},
    { 'cat_num' : 6, 'cat_lib': u'Sprint intermédiaire', 'maillot_couleur': 'vert'},
    { 'cat_num' : 7, 'cat_lib': u'Sprint final', 'maillot_couleur': 'vert'}
]
def add_categorie(label):

    categories = {
        'col-4' : 1,
        'col-3' : 2,
        'col-2' : 3,
        'col-1' : 4,
        'col-H' : 5,
        'sprint': 6,
        'sprint-f': 7
    }


    if label not in categories:
        return 'NULL'

    return categories[label]

table_villes = {}
i_ville = 1
def add_ville(nom_ville):
    global table_villes
    global i_ville
    if nom_ville in table_villes.keys():
        return table_villes[nom_ville]
    else:
        table_villes[nom_ville] = i_ville
        i_ville = i_ville + 1
        return i_ville - 1

table_etapes = []
table_points = []

def parse_etape(etape_num):
    html = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/fiche-etape/cote-sport/itineraire.html')
    soup = BeautifulSoup.BeautifulSoup(html)

    itineraire = soup.find('div', attrs={'class': u'tab-itineraire'})

    etape = {}


    etape['etape_num'] = etape_num
    etape['etape_nom'] = itineraire.find('span', attrs={'class': u'etape'}).string
    etape['points'] = []

    lines = itineraire.findAll('tr')

    i = 0
    for line in lines:
        if 'class' not in line.attrs.keys():
            continue

        is_point = True

        point = {}
        cells = line.findAll('td')

        point['cat_num'] = 'NULL'

        for cell in cells:
            cell_class = cell['class'][0]
            if cell_class == 'flag' and cell.find('span'):
                span = cell.find('span')
                point['cat_num'] = add_categorie(span['class'][0])
            elif cell_class == 'place':
                point['pt_pass_nom'] = cell.string
            elif cell_class == 'km':
                if cell.string is None:
                    is_point = False
                    break
                elif 'pt_pass_km_arr' in point:
                    point['pt_pass_km_dep'] = cell.string
                else:
                    point['pt_pass_km_arr'] = cell.string
            elif cell_class == 'hour':
                if 'pt_pass_horaire' not in point:
                    point['pt_pass_horaire'] = cell.string

        if not is_point:
            continue

        point['etape_num'] = str(etape_num)
        point['pt_pass_num'] = str(i + 1)

        #si c'est en majuscule, c'est une ville
        if point['pt_pass_nom'].upper() == point['pt_pass_nom']:
            point['ville_num'] = add_ville(point['pt_pass_nom'])
            point['pt_pass_ville_nom'] = point['pt_pass_nom']
        else :
            point['ville_num'] = 'NULL'
            point['pt_pass_ville_nom'] = 'NULL'

        #si on a pas l'horaire de passage
        if point['pt_pass_horaire'] is None:
            point['pt_pass_horaire'] = '00h00'

        etape['points'].append(point)
        i = i + 1

    etape['etape_distance'] = etape['points'][0]['pt_pass_km_arr']
    etape['ville_nom_debuter'] = etape['points'][0]['pt_pass_nom'].upper()
    etape['ville_num_debuter'] = add_ville(etape['points'][0]['pt_pass_nom'].upper())
    etape['ville_nom_finir'] = etape['points'][len(etape['points']) - 1]['pt_pass_nom'].upper()
    etape['ville_num_finir'] = add_ville(etape['points'][len(etape['points']) - 1]['pt_pass_nom'].upper())
    etape['points'][len(etape['points']) - 1]['cat_num'] = add_categorie('sprint-f')


    #calcul de la date
    etape_date = debut_tour + datetime.timedelta(etape_num - 1)
    if etape_num >  repos_1:
        etape_date = etape_date + datetime.timedelta(1)
    if etape_num > repos_2:
        etape_date = etape_date + datetime.timedelta(1)
    etape['etape_date'] = etape_date.strftime('%d/%m/%Y')

    return etape



for i in range (1, 22):
    etape = parse_etape(i)
    table_etapes.append(etape)

    for point in etape['points']:
        table_points.append(point)


#On remplit le fichier ville
f_ville = open('ville.sql', 'w')
f_ville.write('INSERT INTO VILLE (VILLE_NUM, VILLE_NOM) VALUES \n')

for (ville_nom, ville_num) in table_villes.items():
    f_ville.write(("(" + str(table_villes[ville_nom]) + ", '" + ville_nom +  "'),\n").encode('utf8'))

#On remplit le fichier categorie
f_ville = open('categorie.sql', 'w')
f_ville.write('INSERT INTO CATEGORIE (CAT_NUM, CAT_LIB, MAILLOT_COUREUR) VALUES \n')

for categorie in table_categories:
    f_ville.write(("(" + str(categorie['cat_num']) + ", '" + categorie['cat_lib'] +  "', '" + categorie['maillot_couleur'] + "'),\n").encode('utf8'))

#On remplit le fichier etape
f_etape = open('etape.sql', 'w')
f_etape.write('INSERT INTO ETAPE (TOUR_ANNEE, ETAPE_NUM, ETAPE_NOM, ETAPE_DATE, ETAPE_DISTANCE, TETAPE_LIB, VILLE_NUM_DEBUTER, VILLER_NUM_FINIR, VILLE_NOM_DEBUTER, VILLE_NOM_FINIR) VALUES \n')

for etape in table_etapes:
    f_etape.write(("(2013, " + str(etape['etape_num']) + ", '" + etape['etape_nom'] +  "', '" + etape['etape_date'] +   "', " + etape['etape_distance'] +   ", 'ligne', " + str(etape['ville_num_debuter']) + ", " + str(etape['ville_num_finir']) + ", '" + etape['ville_nom_debuter'] + "', '" + etape['ville_nom_finir'] +  "'),\n").encode('utf8'))


#On remplit le point de passage
f_point_passage = open('point_passage.sql', 'w')
f_point_passage.write('INSERT INTO POINT_PASSAGE (TOUR_ANNEE, ETAPE_NUM, PT_PASS_NUM, PT_PASS_NOM, PT_PASS_VILLE_NOM, PT_PASS_KM_DEP, PT_PASS_KM_ARR, PT_PASS_ALT, PT_PASS_HORAIRE, VILLE_NUM, CAT_NUM, UTIL_NUM) VALUES \n')

for point in table_points:
    print point
    f_point_passage.write(("(2013, " + str(point['etape_num']) + ", " + str(point['pt_pass_num']) + ", '" + point['pt_pass_nom'] + "', '" + point['pt_pass_ville_nom'] + "', " + str(point['pt_pass_km_dep']) + ", " + str(point['pt_pass_km_arr']) +  ", 100, '" +  point['pt_pass_horaire'] + "', " + str(point['ville_num']) + ", " + str(point['cat_num']) + ", NULL, ),\n").encode('utf8'))


