/*
 *  ldap.m
 *  ldapsearch
 *
 *  Created by David Syzdek on 11/2/10.
 *  Copyright 2010 David M. Syzdek. All rights reserved.
 *
 */


#include <stdio.h>
#include "ldap.h"

/* Specify the search criteria here. */
//#define HOSTNAME "10.0.0.125"
//#define PORTNUMBER 389
//#define BASEDN "DC=10P-PORTAL,DC=COM"
//#define BIND_DN "firdous@10p-portal.com"
//#define BIND_PW "tenpearls"
//#define SCOPE LDAP_SCOPE_SUBTREE
//#define FILTER "(objectClass=*)"

#define HOSTNAME "ldap.ten-pearl.com"
#define PORTNUMBER 389
#define BASEDN "dc=ten-pearl,dc=com"
#define BIND_DN "uid=firdous,ou=staff,dc=ten-pearl,dc=com"
#define BIND_PW "tenpearls"
#define SCOPE LDAP_SCOPE_SUBTREE
#define FILTER "(sn=firdous)"

LDAP *
ldap_init( LDAP_CONST char *defhost, int defport );
int
ldap_simple_bind_s( LDAP *ld, LDAP_CONST char *dn, LDAP_CONST char *passwd );
int
ldap_unbind( LDAP *ld );

int my_ldap_test(){
    LDAP          *ld;
    LDAPMessage   *result, *e;
    char          *dn;
    int           version, rc;
    
    /* STEP 1: Get a handle to an LDAP connection and
     set any session preferences. */
    if ( (ld = ldap_init( HOSTNAME, PORTNUMBER )) == NULL ) {
        perror( "ldap_init" );
        return( 1 );
    }
    
    /* Use the LDAP_OPT_PROTOCOL_VERSION session preference to specify
     that the client is an LDAPv3 client. */
    version = LDAP_VERSION3;
    ldap_set_option( ld, LDAP_OPT_PROTOCOL_VERSION, &version );
    
    /* STEP 2: Bind to the server.
     In this example, the client binds anonymously to the server
     (no DN or credentials are specified). */
    rc = ldap_simple_bind_s( ld, BIND_DN, BIND_PW );
    if ( rc != LDAP_SUCCESS ) {
        fprintf(stderr, "ldap_simple_bind_s: %s\n", ldap_err2string(rc));
        return( 1 );
    }
    
    /* Print out an informational message. */
    printf( "Searching the directory for entries\n"
           " starting from the base DN %s\n"
           " within the scope %d\n"
           " matching the search filter %s...\n\n",
           BASEDN, SCOPE, FILTER );
    
    /* STEP 3: Perform the LDAP operations.
     In this example, a simple search operation is performed.
     The client iterates through each of the entries returned and
     prints out the DN of each entry. */
    rc = ldap_search_ext_s( ld, BASEDN, SCOPE, FILTER, NULL, 0,
                           NULL, NULL, NULL, 0, &result );
    if ( rc != LDAP_SUCCESS ) {
        fprintf(stderr, "ldap_search_ext_s: %s\n", ldap_err2string(rc));
        return( 1 );
    }
    for ( e = ldap_first_entry( ld, result ); e != NULL;
         e = ldap_next_entry( ld, e ) ) {
        if ( (dn = ldap_get_dn( ld, e )) != NULL ) {
            printf( "dn: %s\n", dn );
            ldap_memfree( dn );
        }
    }
    ldap_msgfree( result );
    
    /* STEP 4: Disconnect from the server. */
    ldap_unbind( ld );
    return( 0 );
}

