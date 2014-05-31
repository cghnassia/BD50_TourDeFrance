# -*-coding:UTF-8 -*

from urllib import urlopen
import bs4 as BeautifulSoup
import datetime
import re

def resultat_etape(etape_num):

    resultats = {}

    #Classement etape
    html_ite = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/classement/bloc-classement-page/ITE.html')    #classement etape
    soup_ite = BeautifulSoup.BeautifulSoup(html_ite)

    if soup_ite.find('tbody') is not None:

        for line in soup_ite.find('tbody').findAll('tr'):

            resultat = {}
            part_num = 0
            for cell in line.findAll('td'):
                if cell == line.find('td'):
                    resultat['etape_class'] = int(float(cell.string))
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_3':
                    part_num = int(cell.string)
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_5':
                    tps = re.search(r'^(([0-9]*)h )?([0-9]*)\' ([0-9]*)\'\'$', cell.string)
                    resultat['etape_tps'] = 0
                    if tps.group(tps.lastindex) is not None:
                        resultat['etape_tps'] += int(tps.group(tps.lastindex)) * 10
                    if tps.group(tps.lastindex - 1) is not None:
                        resultat['etape_tps'] += int(tps.group(tps.lastindex - 1)) * 60 * 10
                    if tps.group(tps.lastindex - 2) is not None:
                        resultat['etape_tps'] += int(tps.group(tps.lastindex - 2)) * 3600 * 10
                elif cell == line.findAll('td')[len(line.findAll('td')) - 1]:
                    ecart = re.search(r'\+ ([0-9]*)\' ([0-9]*)\'\'$', cell.string)
                    resultat['etape_ecart'] = 0
                    if ecart is not None and ecart.lastindex > 0:
                        resultat['etape_ecart'] += int(ecart.group(ecart.lastindex)) * 10
                    if ecart is not None and ecart.lastindex > 1:
                        resultat['etape_ecart'] += int(ecart.group(1)) * 60 * 10

            resultats[part_num] = resultat


    #Classement général
    html_itg = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/classement/bloc-classement-page/ITG.html')    #classement etape
    soup_itg = BeautifulSoup.BeautifulSoup(html_itg)

    if soup_itg.find('tbody') is not None:

        for line in soup_itg.find('tbody').findAll('tr'):

            resultat = {}
            part_num = 0
            for cell in line.findAll('td'):
                if cell == line.find('td'):
                    resultat['gene_class'] = int(float(cell.string))
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_3':
                    part_num = int(cell.string)
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_5':
                    tps = re.search(r'^([0-9]*)h ([0-9]*)\' ([0-9]*)\'\'$', cell.string)
                    resultat['gene_tps'] = 0
                    if tps.lastindex > 0:
                        resultat['gene_tps'] += int(tps.group(tps.lastindex)) * 10
                    if tps.lastindex > 1:
                        resultat['gene_tps'] += int(tps.group(tps.lastindex - 1)) * 60 * 10
                    if tps.lastindex > 2:
                        resultat['gene_tps'] += int(tps.group(1)) * 3600 * 10
                elif cell == line.findAll('td')[len(line.findAll('td')) - 1]:
                    ecart = re.search(r'\+ ([0-9]*)\' ([0-9]*)\'\'$', cell.string)
                    resultat['gene_ecart'] = 0
                    if ecart is not None and ecart.lastindex > 0:
                        resultat['gene_ecart'] += int(ecart.group(ecart.lastindex)) * 10
                    if ecart is not None and ecart.lastindex > 1:
                        resultat['gene_ecart'] += int(ecart.group(1)) * 60 * 10

            if part_num in resultats:
                resultats[part_num] = dict(resultats[part_num].items() + resultat.items())
            else:
                resultats[part_num] = resultat


    #Classement général montagne
    html_img = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/classement/bloc-classement-page/IMG.html')    #classement etape
    soup_img = BeautifulSoup.BeautifulSoup(html_img)

    if soup_img.find('tbody') is not None:

        for line in soup_img.find('tbody').findAll('tr'):

            resultat = {}
            part_num = 0
            for cell in line.findAll('td'):
                if cell == line.find('td'):
                    resultat['gene_class_mont'] = int(float(cell.string))
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_3':
                    part_num = int(cell.string)
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_5':
                    points = re.search(r'[0-9-]*', cell.string)
                    resultat['gene_pts_mont'] = int(points.group(0))

            resultats[part_num] = dict(resultats[part_num].items() + resultat.items())

     #Classement général sprint
    html_ipg = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/classement/bloc-classement-page/IPG.html')    #classement etape
    soup_ipg = BeautifulSoup.BeautifulSoup(html_ipg)

    if soup_ipg.find('tbody') is not None:

        for line in soup_ipg.find('tbody').findAll('tr'):

            resultat = {}
            part_num = 0
            for cell in line.findAll('td'):
                if cell == line.find('td'):
                    resultat['gene_class_sprint'] = int(float(cell.string))
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_3':
                    part_num = int(cell.string)
                elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_5':
                    points = re.search(r'[0-9-]*', cell.string)
                    resultat['gene_pts_sprint'] = int(points.group(0))

            resultats[part_num] = dict(resultats[part_num].items() + resultat.items())


    #Classement montagne étape
    html_ime = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/classement/bloc-classement-page/IME.html')    #classement etape
    soup_ime = BeautifulSoup.BeautifulSoup(html_ime)

    points_passage = {} #résultats des points de passage
    if soup_ipg.findAll('table') is not None:

        for table in soup_ime.findAll('table'):

            if not table.has_attr('itequality'):
                continue

            caption = re.search(r'(.*) -', table.find('caption').string)

            if caption is None:
                continue

            nom_point = caption.group(1)

            point_passage = {}
            for line in table.find('tbody').findAll('tr'):

                resultat = {}
                for cell in line.findAll('td'):
                    if cell == line.find('td'):
                        rank = int(float(cell.string))
                    elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_3':
                        part_num = int(cell.string)
                    elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_5':
                        re_points = re.search(r'[0-9-]*', cell.string)
                        points = int(re_points.group(0))

                if 'etape_pts_mont' in  resultats[part_num]:
                    resultats[part_num]['etape_pts_mont'] += points
                else:
                    resultats[part_num]['etape_pts_mont'] = points


                resultat = {'part_num': part_num, 'points': points}
                point_passage[rank] = resultat

            points_passage[nom_point] = point_passage

    #Classement sprint étape
    html_ipe = urlopen('http://www.letour.fr/le-tour/2013/fr/' + str(etape_num) + '00/classement/bloc-classement-page/IPE.html')    #classement etape
    soup_ipe = BeautifulSoup.BeautifulSoup(html_ipe)

    if soup_ipe.findAll('table') is not None:

        for table in soup_ipe.findAll('table'):

            if not table.has_attr('itequality'):
                continue

            caption = re.search(r'(.*) -', table.find('caption').string)

            if caption is None:
                continue

            nom_point = caption.group(1)

            point_passage = {}
            for line in table.find('tbody').findAll('tr'):

                resultat = {}
                for cell in line.findAll('td'):
                    if cell == line.find('td'):
                        rank = int(float(cell.string))
                    elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_3':
                        part_num = int(cell.string)
                    elif 'class' in cell.attrs.keys() and cell['class'][0] == 'col_5':
                        re_points = re.search(r'[0-9-]*', cell.string)
                        points = int(re_points.group(0))

                if 'etape_pts_sprint' in  resultats[part_num]:
                    resultats[part_num]['etape_pts_sprint'] += points
                else:
                    resultats[part_num]['etape_pts_sprint'] = points


                resultat = {'part_num': part_num, 'points': points}
                point_passage[rank] = resultat

            points_passage[nom_point] = point_passage

    return {'coureurs': resultats, 'points_passage': points_passage}


etapes = {}
points_passage = {}

for i in range (1, 22):

    print '---------get info for etape ' + str(i) + '-------------'

    resultat = resultat_etape(i)
    etapes[i] = resultat['coureurs']
    points_passage[i] = resultat['points_passage']


f_terminer_etape = open('terminer_etape.sql', 'w')
f_terminer_etape.write('INSERT INTO TERMINER_ETAPE (TOUR_ANNEE, PART_NUM, ETAPE_NUM, ETAPE_TPS, ETAPE_CLASS, ETAPE_PTS_MONT, ETAPE_PTS_SPRINT, GENE_TPS, GENE_CLASS, GENE_PTS_MONT, GENE_CLASS_MONT, GENE_PTS_SPRINT, GENE_CLASS_SPRINT) VALUES \n')

for (etape_num, etape) in etapes.items():

    for (coureur_num, coureur) in etape.items():

        #if 'etape_tps' not in coureur:
        #    coureur['etape_tps'] = 'NULL'

        if 'etape_pts_sprint' not in coureur:
            coureur['etape_pts_sprint'] = 0

        if 'etape_pts_mont' not in coureur:
            coureur['etape_pts_mont'] = 0

        if 'gene_pts_sprint' not in coureur:
            coureur['gene_pts_sprint'] = 0

        if 'gene_pts_mont' not in coureur:
            coureur['gene_pts_mont'] = 0

        if 'gene_class_sprint' not in coureur:
            coureur['gene_class_sprint'] = 'NULL'

        if 'gene_class_mont' not in coureur:
            coureur['gene_class_mont'] = 'NULL'

        if 'etape_tps' not in coureur:
            coureur['etape_tps'] = 'NULL'

        if 'etape_class' not in coureur:
            coureur['etape_class'] = 'NULL'

        #print('2013' + ' - ' + str(coureur_num) + ' - ' + str(etape_num) + ' - ' + str(coureur['etape_tps']) + ' - ' + str(coureur['etape_class']) + ' - ' + str(coureur['etape_pts_mont']) + ' - ' + str(coureur['etape_pts_sprint']) + ' - ' + str(coureur['gene_tps']) + ' - ' + str(coureur['gene_class']) + ' - ' + str(coureur['gene_pts_mont']) + ' - ' + str(coureur['gene_class_mont']) + ' - ' + str(coureur['gene_pts_sprint']) + ' - ' + str(coureur['gene_class_sprint']))
        f_terminer_etape.write(('(2013' + ', ' + str(coureur_num) + ', ' + str(etape_num) + ', ' + str(coureur['etape_tps']) + ', ' + str(coureur['etape_class']) + ', ' + str(coureur['etape_pts_mont']) + ', ' + str(coureur['etape_pts_sprint']) + ', ' + str(coureur['gene_tps']) + ', ' + str(coureur['gene_class']) + ', ' + str(coureur['gene_pts_mont']) + ', ' + str(coureur['gene_class_mont']) + ', ' + str(coureur['gene_pts_sprint']) + ', ' + str(coureur['gene_class_sprint']) + '),\n').encode('utf8'))


f_passer = open('passer.sql', 'w')
f_passer.write('INSERT INTO PASSER (TOUR_ANNEE, ETAPE_NUM, PT_PASS_NOM, PART_NUM, PASS_CLASS, PASS_TPS) VALUES \n')

for (etape_num, etape) in points_passage.items():

    for (point_nom, point_passage) in etape.items():

        for (rank, resultat) in point_passage.items():

            f_passer.write(("(2013, " + str(etape_num) + ", '" + point_nom + "', " + str(resultat['part_num']) + ", " + str(rank) + ", NULL),\n").encode('utf8'))



