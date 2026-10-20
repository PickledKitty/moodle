<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'pgsql';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'db';           // service name from docker-compose
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodle';
$CFG->dbpass    = getenv('MOODLE_DB_PASS') ?: 'moodle';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = [
    'dbport'  => 5432,
    'dbsocket' => '',
];

$CFG->wwwroot   = 'http://localhost:8000';  // Rewritten by postCreate.sh in Codespaces.
$CFG->sslproxy  = false;                    // Set to true by postCreate.sh in Codespaces.
$CFG->reverseproxy = false;                 // Set to true by postCreate.sh in Codespaces.
$CFG->dataroot  = '/var/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 0777;

// Apache sends unknown paths to public/r.php (see Dockerfile), so the 5.x router is configured.
$CFG->routerconfigured = true;

// Developer settings
$CFG->debug        = E_ALL;
$CFG->debugdisplay = 1;
$CFG->debugsmtp    = 1;

// Speed up development — disable caching
$CFG->cachejs         = false;
$CFG->themedesignermode = true;
$CFG->langstringcache = false;

// Snap theme (your theme)
$CFG->forced_plugin_settings['theme_snap'] = [];

require_once(__DIR__ . '/lib/setup.php');