--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body UI_AUTHENTIFICATION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_AUTHENTIFICATION" AS 


  PROCEDURE formLogin IS
   BEGIN
    htp.print('<div class="w90 txtleft">');
      htp.FORmopen(curl=>'ui_authentification.verifAuth', cmethod=>'POST');
      htp.print('Login:');
			htp.FORmtext('login', cattributes=>'style="width:200px;"');
			htp.print('Mot de passe:');
			htp.FORmPassword('pass', cattributes=>'style="width:200px;"');
      htp.FORmhidden('prev_url',owa_util.get_procedure);
			htp.FORmsubmit(cvalue=>'OK');
			htp.FORmclose;
    htp.print('</div>');
  END formLogin;

  PROCEDURE formLogged(login varchar2 default'') IS
   BEGIN
    htp.print('<div class="w90 txtleft">');
      htp.print(ui_utils.getCookieValue('user')||' connecté');
      htp.print('</br>');
      htp.anchor ('ui_administration.gestion','Administration');
      htp.print('</br>');
      htp.anchor ('ui_authentification.logOut','Déconnexion');
      
    htp.print('</div>');
  END formLogged;
  
  FUNCTION userExist(login varchar2, pass varchar2) return boolean IS
  v_test number(1);
  BEGIN
    select 
      count(util_num) into v_test
    from 
      utilisateur
    where util_nom = login
    AND util_mdp = pass;
    
    IF (v_test=1) THEN
      return TRUE;
    ELSE
      return FALSE;
    END IF;
  END userExist;
  
  FUNCTION getUser(login varchar2) return utilisateur%rowtype IS
  v_user utilisateur%rowtype;
  BEGIN
    select
      * into v_user
    from
      utilisateur
    where util_nom = login;
    return v_user;
  end getUSer;
  
  PROCEDURE verifAuth(login varchar2, pass varchar2, prev_url varchar2) IS
  v_user utilisateur%rowtype;
  BEGIN
   IF (ui_authentification.userExist(login,pass)) THEN
   v_user:=getUser(login);
        owa_util.mime_header('text/html', FALSE);
        owa_cookie.send(name=>'user',value=>login);
        owa_cookie.send(name=>'isLogged',value=>1);
        owa_cookie.send(name=>'profil',value=>v_user.profil_lib);  
        owa_util.redirect_url('ui_commun.ui_home');
        owa_util.http_header_close;
   ELSE
        owa_cookie.remove('error',null);
        owa_util.mime_header('text/html', FALSE);
        owa_cookie.send(name=>'error',value=>1);
        owa_util.redirect_url(prev_url);
        owa_util.http_header_close;
   END IF;
  END verifAuth;
  
  PROCEDURE formError IS
  BEGIN
        htp.print('<div><font color="red">Erreur de login et/ou mot de passe</font></div>');
  END formError;
  
  PROCEDURE cadreAuth IS
  BEGIN
   
   IF(ui_utils.existCookie('isLogged')) THEN
       IF(ui_utils.getCookieValue('isLogged')=1) THEN
          ui_authentification.formLogged;
        END IF;
   ELSE
    htp.anchor ('ui_authentification.login','Connexion');
    
 END IF;
  END cadreAuth;
  
  PROCEDURE logOut IS
  BEGIN
    owa_cookie.remove('user',null);
    owa_cookie.remove('isLogged',null);
    owa_cookie.remove('profil',null);
    owa_cookie.remove('error',null);
    
  	owa_util.mime_header('text/html', FALSE);
	  owa_util.redirect_url('ui_commun.ui_home');
    owa_util.http_header_close;
  END logOut;
  
  
  
    PROCEDURE login IS
  BEGIN
      UI_COMMUN.UI_HEAD;
	    UI_COMMUN.UI_MAIN_OPEN;
      htp.print('<div class="row h2-like greyFrame">Authentification</div></br></br>');
      IF(ui_utils.existCookie('error')) THEN
         IF(ui_utils.getCookieValue('error')=1) THEN
          ui_authentification.formError;
          ui_authentification.formLogin;
        END IF;
     ELSE
       ui_authentification.formLogin;
     END IF;
      UI_COMMUN.UI_MAIN_CLOSE;
      UI_COMMUN.UI_FOOTER;

        
  END login;
  
END UI_AUTHENTIFICATION;

/
