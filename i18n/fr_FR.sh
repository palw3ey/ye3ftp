# localisation file for ye3ftp
# website : https://github.com/palw3ey/ye3ftp
# language : fr_FR
# translation by : palw3ey <palw3ey@gmail.com>
# create : 20231204
# update : 20231204

i_allow_write="autoriser l'écriture"
i_anonymous="anonyme"
i_apply_permission_on_the_folder="appliquer l'autorisation sur le dossier"
i_create_folder="créer le dossier"
i_create_log_file="créer le fichier log"
i_create_user="créer l'utilisateur"
i_create_virtual_user_config_directory="créer le dossier de configuration pour utilisateur virtuel"
i_debug="débogage"
i_disable="désactiver"
i_enable="activer"
i_error="erreur"
i_force="forcer"
i_general_configuration="configuration general"
i_implicit="implicite"
i_missing_or_invalid_argument="argument manquant ou invalide"
i_passive="passif"
i_ready="prêt"
i_sorry_user_does_not_exist="désolé, l'utilisateur n'existe pas"
i_start="démarrer"
i_use_individual_folder="utiliser un dossier individuel"
i_use_same_folder="utiliser le même dossier"
i_user_already_exist="l'utilisateur existe déjà"
i_HELP="
--action=text
  add            : Ajouter un nouvel utilisateur (ARG: user, password)
  update         : Mettre à jour le mot de passe (ARG: user, password)
  delete         : Supprimer un utilisateur (ARG: user)
  exist          : Vérifier si l'utilisateur existe
  list           : Lister tous les utilisateurs disponibles
  log            : Afficher le journal vsftpd
  stop           : Arrêter le service vsftpd
  restart        : Redémarrer le service vsftpd
  shutdown       : Arrêter le serveur

--user=text      : Nom d'utilisateur
--password=text  : Mot de passe (ex: mypassword)

Exemple :
mgmt --action=add --user=tux2 --password=1234
"
