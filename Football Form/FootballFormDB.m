//
//  FootballFormDB.m
//  Football Form
//
//  Created by Aaron Wilkinson on 29/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "FootballFormDB.h"

@implementation FootballFormDB

+(FootballFormDB *)sharedInstance
{
    // the instance of this class is stored here
    static FootballFormDB *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }

    return myInstance;
}

-(void)getDB {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    
    BOOL shouldDownloadDB = YES;
    
    if (shouldDownloadDB) {
        databasePath = [[NSUserDefaults standardUserDefaults]objectForKey:@"pathDatabaseIsSavedIn"];
    } else {
        databasePath = [docsDir stringByAppendingPathComponent:@"football_form_database_new.db"];
    }
    // Build the path to the database file
    //databasePath = [docsDir stringByAppendingPathComponent:@"football_site.db"];
    
    
    
}

-(NSMutableArray *)getFixturesForDateNew:(NSString *)date andFixture:(NSString *)fixtureID {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL;
        
        querySQL = [NSString stringWithFormat:@"SELECT f.teams_home_id, f.teams_home_name, f.team_home_standing, f.teams_away_id, f.teams_away_name, f.league_id, f.league_type, f.fixture_date, f.start_time,f.notes, f.team_home_score, f.team_away_score, f.status\
        FROM fixtures f\
        LEFT OUTER JOIN sub_league sl\
        ON sl.id=f.league_id\
        WHERE (fixture_date = '%@ 00:00:00' OR fixture_date = '%@')\
        AND (sl.league_id = %@ OR f.league_id = %@)\
        ORDER BY start_time", date, date, fixtureID, fixtureID];
                
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *team_home_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *team_home_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *team_home_standing = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *teams_away_id = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *teams_away_name = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *league_type = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *fixture_date = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *start_time = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *notes = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 9)];
                if (notes.length ==0) {
                    notes = @"none";
                }
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *teamAwayScore = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *teamStatus = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 12)];

                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:team_home_id, @"team_home_id", team_home_name, @"team_home_name", team_home_standing, @"team_home_standing", teams_away_id, @"team_away_id", teams_away_name, @"team_away_name",league_id, @"league_id",league_type, @"league_type", fixture_date, @"fixture_date", start_time, @"start_time", notes, @"notes", teamHomeScore, @"team_home_score", teamAwayScore, @"team_away_score", teamStatus, @"teamStatus", nil];
                
                [resultArray addObject:dict];
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)getFixturesForDate:(NSString *)date andFixture:(NSString *)fixtureID initialFID:(NSString *)initialFID{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
       
        NSString *querySQL;
        
        if (date==nil) {
            
            querySQL = [NSString stringWithFormat:
                        @"SELECT teams_home_id, teams_home_name, team_home_standing, teams_away_id, teams_away_name, league_id, league_type, fixture_date, start_time,notes FROM fixtures WHERE league_id='%@' OR league_id=%@", fixtureID, initialFID];
            
        } else {
            
            querySQL = [NSString stringWithFormat:
                        @"SELECT teams_home_id, teams_home_name, team_home_standing, teams_away_id, teams_away_name, league_id, league_type, fixture_date, start_time,notes FROM fixtures WHERE (fixture_date = '%@' OR fixture_date = '%@ 00:00:00') AND (league_id='%@' OR league_id=%@)", date, date, fixtureID, initialFID];
        }
        
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *team_home_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *team_home_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *team_home_standing = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *teams_away_id = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *teams_away_name = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *league_type = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *fixture_date = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *start_time = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *notes = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 9)];
                if (notes.length ==0) {
                    notes = @"none";
                }
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:team_home_id, @"team_home_id", team_home_name, @"team_home_name", team_home_standing, @"team_home_standing", teams_away_id, @"team_away_id", teams_away_name, @"team_away_name",league_id, @"league_id",league_type, @"league_type", fixture_date, @"fixture_date", start_time, @"start_time", notes, @"notes",nil];
                
                [resultArray addObject:dict];
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)getContinents {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT continent FROM countries WHERE continent IS NOT NULL AND should_show_on_app='Y' GROUP BY continent"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *continent = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                
                [resultArray addObject:continent];
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}


-(NSMutableArray *)getCountries:(NSString *)continent {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM countries WHERE should_show_on_app='Y' AND continent='%@' ORDER BY name ASC", continent];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *countryID = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *code = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *seasonID = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 4)];
                
                NSDictionary *dict = @{@"id": countryID, @"name":name, @"code":code, @"seasonID":seasonID};
                
                [resultArray addObject:dict];
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)getFutureFixtureForGame:(NSString *)gameAmount todaysDate:(NSString *)date withFixtureID:(NSString *)fixtureID {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                         @"SELECT team_home.name as home_team_name, team_away.name as away_team_name, f.`fixture_date`, f.`start_time`,team_home.id as home_team_id, team_away.id as away_team_id FROM fixtures f, teams team_home, teams team_away WHERE f.`teams_away_id` = team_away.id AND f.teams_home_id = team_home.id AND f.league_id = '%@' AND DATE(f.`fixture_date`) > '%@' ORDER BY f.`fixture_date` ASC LIMIT %@", fixtureID, date, gameAmount];
        
        
        querySQL = [querySQL stringByReplacingOccurrencesOfString:@" AND f.league_id = '999' " withString:@" "];
       
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSDictionary *dict = [NSDictionary new];
                    
                    NSString *home_team_name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 0)];
                    
                    NSString *away_team_name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                    
                    NSString *dateAndTime = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 2)];
                    
                    NSString *startTime = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 3)];
                    
                    NSString *teamHomeId = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 4)];
                    
                    NSString *teamAwayId = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                    
                    
                    dict = [[NSDictionary alloc] initWithObjectsAndKeys:home_team_name, @"team_home_name", away_team_name, @"team_away_name", dateAndTime, @"date", startTime, @"start_time", teamHomeId, @"team_home_id", teamAwayId, @"team_away_id", nil];
                    [resultArray addObject:dict];
                    
                    
                }
                
                
            } else {
                return nil;
            }
        
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        return resultArray;
    } else {
        
    return nil;
        
    }

}

-(NSMutableArray *)getPastFixtureForGame:(NSString *)gameAmount todaysDate:(NSString *)date withFixtureID:(NSString *)fixtureID {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT team_home.name as home_team_name, team_away.name as away_team_name, f.`fixture_date`, f.`start_time`,team_home.id as home_team_id, team_away.id as away_team_id FROM fixtures f, teams team_home, teams team_away WHERE f.`teams_away_id` = team_away.id AND f.teams_home_id = team_home.id AND f.league_id = '%@' AND DATE(f.`fixture_date`) < '%@' ORDER BY f.`fixture_date` DESC LIMIT %@", fixtureID, date, gameAmount];
        
        querySQL = [querySQL stringByReplacingOccurrencesOfString:@" AND f.league_id = '999' " withString:@" "];

        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSDictionary *dict = [NSDictionary new];
                    
                    NSString *home_team_name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 0)];
                    
                    NSString *away_team_name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                    
                    NSString *dateAndTime = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 2)];
                    
                    NSString *startTime = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 3)];
                    
                    NSString *teamHomeId = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 4)];
                    
                    NSString *teamAwayId = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                    
                    
                    dict = [[NSDictionary alloc] initWithObjectsAndKeys:home_team_name, @"team_home_name", away_team_name, @"team_away_name", dateAndTime, @"date", startTime, @"start_time", teamHomeId, @"team_home_id", teamAwayId, @"team_away_id", nil];
                    [resultArray addObject:dict];
                }
                
                
            } else {
                return nil;
            }
        
        
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSMutableArray *)getLeaguesForCountry:(NSString *)countryID {
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM league WHERE country_id=%@ AND should_show_on_app='Y' ORDER BY `sort` ASC", countryID];
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *theirID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                leagueName = [leagueName capitalizedString];
                leagueName = [leagueName stringByReplacingOccurrencesOfString:@"Fa" withString:@"FA"];
                
                NSDictionary *dict = @{@"leagueID": theirID, @"name":leagueName};
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getLeaguesForCountryFixtures:(NSString *)countryID {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT l.* FROM league l, fixtures f\
                              LEFT OUTER JOIN sub_league sl\
                              ON sl.id=f.league_id\
                              WHERE (sl.league_id = l.id OR f.league_id = l.id)\
                              AND l.country_id=%@\
                              AND l.should_show_on_app='Y'\
                              GROUP BY l.id\
                              ORDER BY l.`sort` ASC", countryID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *theirID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                leagueName = [leagueName capitalizedString];
                leagueName = [leagueName stringByReplacingOccurrencesOfString:@"Fa" withString:@"FA"];
                
                NSDictionary *dict = @{@"leagueID": theirID, @"name":leagueName};
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSMutableArray *)getLeagues {
    return nil;
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM league WHERE should_show_on_app='Y' ORDER BY `sorting_order` ASC"];
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSDictionary *dict = [NSDictionary new];
                    
                    NSString *theirID = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 0)];
                    
                    NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                                        
                    leagueName = [leagueName capitalizedString];
                    leagueName = [leagueName stringByReplacingOccurrencesOfString:@"Fa" withString:@"FA"];
                    
                    dict = [[NSDictionary alloc] initWithObjectsAndKeys:theirID, @"leagueID", leagueName, @"name", nil];
                    [resultArray addObject:dict];
                    
                    
                }
            }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)getRSSFeedLinks {
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM rss_feed_links ORDER BY id ASC"];
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *idd = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *url = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                

                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:idd, @"id", name, @"name", url, @"url", nil];
                [resultArray addObject:dict];
                
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)getLeaguesWithAmmendedAll {
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    NSDictionary *dict = [NSDictionary new];
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"000123", @"leagueID", @"All Leagues", @"name", nil];
    [resultArray addObject:dict];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM league WHERE should_show_on_app='Y' ORDER BY `sorting_order` ASC"];
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *theirID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                leagueName = [leagueName capitalizedString];
                leagueName = [leagueName stringByReplacingOccurrencesOfString:@"Fa" withString:@"FA"];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:theirID, @"leagueID", leagueName, @"name", nil];
                [resultArray addObject:dict];
                
                
            }
            
            
        }
        
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
    
}




-(NSMutableArray *)getPreviousGamesForTeam:(NSString *)homeTeamID amountOfGames:(NSString *)amount date:(NSString *)date {
    
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT teams_home_name, teams_away_name, fixture_date, team_away_score, team_home_score, start_time, teams_home_id, teams_away_id, id, status FROM fixtures WHERE (teams_home_id = %@ OR teams_away_id = %@) AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", homeTeamID, homeTeamID, date, amount];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
           // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSDictionary *dict = [NSDictionary new];
                    
                    NSString *home_team_name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 0)];
                    
                    NSString *away_team_name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                    
                    NSString *dateAndTime = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 2)];
                    
                    NSString *teamAwayScore = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 3)];
                    
                    NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 4)];
                    
                    NSString *startTime = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 5)];
                    
                    NSString *teamHomeId = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 6)];
                    
                    NSString *teamAwayId = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 7)];
                    
                    NSString *fixtureID = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 8)];
                    
                    NSString *stat = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 9)];
                    
                    if ([stat isEqualToString:@"Post"]) {
                        teamAwayScore = @"P";
                        teamHomeScore = @"P";
                    }

                    
                    dict = [[NSDictionary alloc] initWithObjectsAndKeys:home_team_name, @"homeTeam", away_team_name, @"awayTeam", dateAndTime, @"fixtureDate",startTime, @"startTime", teamAwayScore, @"teamAwayScore", teamHomeScore, @"teamHomeScore", teamHomeId, @"teamHomeID", teamAwayId, @"teamAwayID", fixtureID, @"fixtureID", nil];
                    [resultArray addObject:dict];
                }
            
            //} else {
                //NSLog(@"Not found");
                //return nil;
            //}
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }

    
}


-(NSString *)getTheTeamIDFromTeamName:(NSString *)teamName {
    [self getDB];
    
    NSString *theid = nil;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT id FROM teams WHERE name = '%@'", teamName];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                theid = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 0)];
                
                
                
                
            }
            
            
            //} else {
            //NSLog(@"Not found");
            //return nil;
            //}
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    return theid;

}


-(NSString *)getTheFixtureID:(NSString *)teamHomeID awayTeamID:(NSString *)awayTeamID fixtureDate:(NSString *)fixtureDate {
    
    [self getDB];
    
    NSString *theid = nil;
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        /* This returns the last 3 games where the team played away
         NSString *querySQL = querySQL  = [NSString stringWithFormat:
         @"SELECT team_home.name as home_team_name, team_away.name as away_team_name, f.`fixture_date`, f.`is_cup_game`, f.`team_away_score`, f.team_home_score FROM fixtures f, teams team_home, teams team_away WHERE f.`teams_away_id` = team_away.id AND f.teams_home_id = %@ AND f.teams_away_id = team_away.id AND f.fixture_date < '%@' LIMIT %@", homeTeamID, date, amount];
         
         
         */
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT id FROM fixtures WHERE teams_home_id = '%@' AND teams_away_id = '%@' AND fixture_date = '%@'", teamHomeID, awayTeamID, fixtureDate];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                theid = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                
            }
            
            
            //} else {
            //NSLog(@"Not found");
            //return nil;
            //}
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    return theid;
}

- (NSMutableArray *)getFixtureDataFromFixtureID:(NSString *)fixtureID {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT id, teams_home_id, teams_away_id, fixture_date, league_id, team_home_score, team_away_score, status, notes, teams_home_name, teams_away_name FROM fixtures WHERE id = '%@'", fixtureID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
                if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *theFixtureID = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamHomeID = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamAwayID = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *leagueID = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 4)];

                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *teamAwayScore = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *status = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *matchNotes = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *teamHomeName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *teamAwayName = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 10)];
                
                if ([status isEqualToString:@"Post"]) {
                    teamHomeScore = @"P";
                    teamAwayScore = @"P";
                }
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:theFixtureID, @"fixtureID", teamHomeID, @"teamHomeID", teamAwayID, @"teamAwayID", fixtureDate, @"fixtureDate", leagueID, @"leagueID", teamHomeScore, @"teamHomeScore", teamAwayScore, @"teamAwayScore", status, @"matchStatus", matchNotes, @"matchNotes", teamHomeName, @"teamHomeName", teamAwayName, @"teamAwayName", nil];
                
                
                [resultArray addObject:dict];
                
            }
            
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }


}


-(NSMutableArray *)getGoalScorersPerMatchID:(NSString *)matchID {
    
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM goals_scored WHERE match_id='%@' ORDER BY team_side", matchID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *goalID = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *matchID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *playerName = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *timeScoredIn = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *dateAdded = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *type = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *period = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *teamSide = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 9)];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:goalID, @"id", matchID, @"matchID", teamID, @"teamID", playerID, @"playerID", playerName, @"playerName", timeScoredIn, @"timeScoredIn", dateAdded, @"dateAdded", type, @"type", period, @"period", teamSide, @"teamSide", nil];
                
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSString *)getTeamPosition:(NSString *)teamID leagueID:(NSString *)leagueID {
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK) {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT position FROM team_positions tp\
                                          LEFT OUTER JOIN sub_league sl ON sl.id=tp.league_id\
                                          WHERE (sl.league_id = %@ OR tp.league_id = %@)\
                                          AND tp.teams_id = %@\
                                          ORDER BY date_added DESC\
                                          LIMIT 1", leagueID, leagueID, teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                const char* fa = (const char*)sqlite3_column_text(statement, 0);
                NSString *pos = fa == NULL ? @"" : [[NSString alloc] initWithUTF8String:fa];

                return pos;
            
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    return @"";
}

//sshleagueid
- (NSMutableArray *)getTeamDataFromID:(NSString *)teamID {
    
    [self getDB];
    
    NSString *carriedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:LeagueToCarry:LeagueID"];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.teams_id, tp.team_name, tp.points FROM team_positions tp, teams t WHERE tp.teams_id = %@ and t.id=teams_id", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *theTeamID = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *position = [self getTeamPosition:teamID leagueID:carriedLeagueID];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:theTeamID, @"id", name, @"teamName", points, @"points", position, @"position", nil];
                
                [resultArray addObject:dict];
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}


- (NSMutableArray *)getLeagueTableFilterByGamesPlayed:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByGamesPlayedSubleagues:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_played_amount DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                //something wrong with 26
                
                const char* fa = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = fa == NULL ? nil : [[NSString alloc] initWithUTF8String:fa];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];

            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}


- (NSMutableArray *)getLeagueTableFilterByGamesPlayedSubleagues:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        
        if (groupText.length>0) {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.total_played_amount DESC", leagueID, groupText];
        } else {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_played_amount DESC", leagueID];
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                //something wrong with 26
                
                const char* fa = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = fa == NULL ? nil : [[NSString alloc] initWithUTF8String:fa];
                
                
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                
                
                
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

- (NSMutableArray *)getLeagueTableHome:(NSString *)leagueID orderBy:(NSString *)orderBy groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableHomeSubleague:leagueID orderBy:orderBy groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL;
        if ([orderBy isEqualToString:@"team_home_points"]) {
            
            if (groupText.length>0) {
                querySQL = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t WHERE tp.league_id='%@' AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.home_total_goals_for - tp.home_total_goals_against) DESC", leagueID, groupText, orderBy];
            } else {
                querySQL = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.home_total_goals_for - tp.home_total_goals_against) DESC", leagueID, orderBy];
            }
            
        } else {
            
            querySQL  = [NSString stringWithFormat:
                         @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t WHERE tp.league_id='%@' AND tp.logoID='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC", leagueID, groupText, orderBy];
            
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
               
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];


                
                NSString *home_goal_difference = nil;
                home_goal_difference = [NSString stringWithFormat:@"%d", [home_total_goals_for intValue]-[home_total_goals_against intValue]];
                
                
                
                NSString *total_played_amounty = nil;
                total_played_amounty = [NSString stringWithFormat:@"%d", [home_win intValue]+[home_draw intValue]+[home_lose intValue]];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"total_points", home_win, @"total_win", home_draw, @"total_draw", home_lose, @"total_lose", home_total_goals_for, @"total_goals_for", home_total_goals_against, @"total_goals_against", is_favourite, @"is_favourite", total_played_amounty, @"total_played_amount", home_goal_difference, @"goal_difference", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
    
}




- (NSMutableArray *)getLeagueTableHomeSubleague:(NSString *)leagueID orderBy:(NSString *)orderBy groupText:(NSString *)groupText {

    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL;
        if ([orderBy isEqualToString:@"team_home_points"]) {
            
            
            if (groupText.length>0) {
                
                querySQL  = [NSString stringWithFormat:
                             @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND t.id=tp.teams_id AND tp.logoID = '%@' GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.home_total_goals_for - tp.home_total_goals_against) DESC", leagueID, groupText, orderBy];
            } else {
                
                querySQL  = [NSString stringWithFormat:
                         @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.home_total_goals_for - tp.home_total_goals_against) DESC", leagueID, orderBy];
            }
            
        } else {
            
            if (groupText.length>0) {
                
                querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID = '%@' GROUP BY tp.id ORDER BY tp.%@ DESC", leagueID, groupText, orderBy];

            } else {
            
                querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC", leagueID, orderBy];
                
            }
            
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                
                
                NSString *home_goal_difference = nil;
                home_goal_difference = [NSString stringWithFormat:@"%d", [home_total_goals_for intValue]-[home_total_goals_against intValue]];
                
                
                
                NSString *total_played_amounty = nil;
                total_played_amounty = [NSString stringWithFormat:@"%d", [home_win intValue]+[home_draw intValue]+[home_lose intValue]];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"total_points", home_win, @"total_win", home_draw, @"total_draw", home_lose, @"total_lose", home_total_goals_for, @"total_goals_for", home_total_goals_against, @"total_goals_against", is_favourite, @"is_favourite", total_played_amounty, @"total_played_amount", home_goal_difference, @"goal_difference", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
    
}





- (NSMutableArray *)getLeagueTableAway:(NSString *)leagueID orderBy:(NSString *)orderBy groupText:(NSString *)groupText {

    NSMutableArray *sub = [self getLeagueTableAwaySubleague:leagueID orderBy:orderBy groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL;
        if ([orderBy isEqualToString:@"team_away_points"]) {
            
             querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.away_total_goals_for - tp.away_total_goals_against) DESC", leagueID, orderBy];
            
        } else {
            
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC", leagueID, orderBy];

        }
       
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                
                NSString *away_goal_difference = nil;
                away_goal_difference = [NSString stringWithFormat:@"%d", [away_total_goals_for intValue]-[away_total_goals_against intValue]];

                
                NSString *total_played_amounty = nil;
                total_played_amounty = [NSString stringWithFormat:@"%d", [away_win intValue]+[away_draw intValue]+[away_lose intValue]];
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_away_points,@"total_points", away_win, @"total_win", away_draw, @"total_draw", away_lose, @"total_lose", away_total_goals_for, @"total_goals_for", away_total_goals_against, @"total_goals_against", is_favourite, @"is_favourite", total_played_amounty, @"total_played_amount", away_goal_difference, @"goal_difference", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableAwaySubleague:(NSString *)leagueID orderBy:(NSString *)orderBy groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL;
        
        if ([orderBy isEqualToString:@"team_away_points"]) {
            
            if(groupText.length>0) {
                querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.away_total_goals_for - tp.away_total_goals_against) DESC", leagueID, groupText, orderBy];
            } else {
                querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC, (tp.away_total_goals_for - tp.away_total_goals_against) DESC", leagueID, orderBy];
            }
            
        } else {
            
            if (groupText.length>0) {
                querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.%@ DESC", leagueID, groupText, orderBy];
            } else {
                querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.%@ DESC", leagueID, orderBy];
            }
            
            
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                
                NSString *away_goal_difference = nil;
                away_goal_difference = [NSString stringWithFormat:@"%d", [away_total_goals_for intValue]-[away_total_goals_against intValue]];
                
                
                NSString *total_played_amounty = nil;
                total_played_amounty = [NSString stringWithFormat:@"%d", [away_win intValue]+[away_draw intValue]+[away_lose intValue]];
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_away_points,@"total_points", away_win, @"total_win", away_draw, @"total_draw", away_lose, @"total_lose", away_total_goals_for, @"total_goals_for", away_total_goals_against, @"total_goals_against", is_favourite, @"is_favourite", total_played_amounty, @"total_played_amount", away_goal_difference, @"goal_difference", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

- (NSMutableArray *)getLeagueTableFilterByWinner:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByWinnerSubleague:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_win DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];

                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];

                
            }
            
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByWinnerSubleague:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = @"";
        
        if(groupText.length>0) {
            querySQL  = [NSString stringWithFormat:
                         @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.total_win DESC", leagueID, groupText];
        } else {
            querySQL  = [NSString stringWithFormat:
                         @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_win DESC", leagueID];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
                
            }
            
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

- (NSMutableArray *)getLeagueTableFilterByDraw:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByDrawSubleague:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite,t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_draw DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];

            
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}



- (NSMutableArray *)getLeagueTableFilterByDrawSubleague:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        
        if (groupText.length>0) {
            querySQL  = [NSString stringWithFormat:
                         @"SELECT tp.*, t.is_favourite,t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.total_draw DESC", leagueID, groupText];

        } else {
            querySQL  = [NSString stringWithFormat:
                         @"SELECT tp.*, t.is_favourite,t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_draw DESC", leagueID];

        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

- (NSMutableArray *)getLeagueTableFilterByGamesLost:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByGamesLostSubleague:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_lose DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];

            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByGamesLostSubleague:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = @"";
        
        if (groupText.length>0) {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.total_lose DESC", leagueID, groupText];
        } else {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_lose DESC", leagueID];
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByGoalsFor:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByGoalsForSubleague:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_goals_for DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByGoalsForSubleague:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        
        if (groupText.length>0) {
            
             querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.total_goals_for DESC", leagueID, groupText];

        } else {
             querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_goals_for DESC", leagueID];

        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByGoalsAgainst:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByGoalsAgainstSubleague:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_goals_against DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }

    
}



- (NSMutableArray *)getLeagueTableFilterByGoalsAgainstSubleague:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK) {
        
        NSString *querySQL = @"";
        
        if (groupText.length>0) {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.total_goals_against DESC",leagueID, groupText];
        } else {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.total_goals_against DESC", leagueID];
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByGoalsDifference:(NSString *)leagueID groupText:(NSString *)groupText {
    
    NSMutableArray *sub = [self getLeagueTableFilterByGoalsDifferenceSubleague:leagueID groupText:groupText];
    
    if (sub.count>0) {
        return sub;
    }
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.goal_difference DESC", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getLeagueTableFilterByGoalsDifferenceSubleague:(NSString *)leagueID groupText:(NSString *)groupText {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        
        if (groupText.length>0) {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id AND tp.logoID='%@' GROUP BY tp.id ORDER BY tp.goal_difference DESC", leagueID, groupText];
        } else {
            querySQL  = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  LEFT OUTER JOIN sub_league sl ON (sl.id=tp.league_id) WHERE sl.league_id=%@ AND t.id=tp.teams_id GROUP BY tp.id ORDER BY tp.goal_difference DESC", leagueID];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* tempid = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = tempid == NULL ? nil : [[NSString alloc] initWithUTF8String:tempid];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getAllPlayers {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT l.id AS theleagueid, p.id AS playerid, p.name AS playername,t.id AS teamid, t.name AS teamname \
                                          FROM league l, teams t, players p \
                                          WHERE l.should_show_on_app='Y' \
                                          AND t.league_id = l.id \
                                          AND p.team_id = t.id"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *player_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *player_name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 4)];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:league_id, @"league_id", player_id, @"player_id", player_name, @"player_name", team_id, @"team_id", [team_name capitalizedString], @"team_name", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getAllPlayersInATeam:(NSString *)teamID  leagueID:(NSString *)leagueID {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT league_id, player_id, player_name, team_id, team_name, p1_goals+p2_goals AS goals_scored FROM form_players_view WHERE team_id=%@ AND league_id=%@ AND type = 0 GROUP BY player_id ORDER BY goals_scored DESC", teamID, leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *player_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *player_name = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_id = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *goals_scored = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];

                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:league_id, @"league_id", player_id, @"player_id", player_name, @"player_name", team_id, @"team_id", [team_name capitalizedString], @"team_name", goals_scored, @"goals_scored", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


- (NSMutableArray *)getPlayersPerLeague:(NSString *)leagueID {
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT l.id AS theleagueid, p.id AS playerid, p.name AS playername,t.id AS teamid, t.name AS teamname \
                                          FROM league l, teams t, players p \
                                          WHERE l.id='%@' \
                                          AND t.league_id = l.id \
                                          AND p.team_id = t.id", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *player_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *player_name = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_id = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 4)];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:league_id, @"league_id", player_id, @"player_id", player_name, @"player_name", team_id, @"team_id", [team_name capitalizedString], @"team_name", nil];
                
                [resultArray addObject:dict];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

- (NSMutableArray *)getLeagueTable:(NSString *)leagueID groupText:(NSString *)groupText {
    [self getDB];
    
    NSString *subleagueCount;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *initial = [NSString stringWithFormat:@"SELECT has_subleague FROM league WHERE id = %@", leagueID];
        
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id AND t.league_id=tp.league_id GROUP BY tp.id ORDER BY tp.position ASC", leagueID];
        
        
        const char *query_stmt = [initial UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                subleagueCount = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                
                if (![subleagueCount isEqualToString:@"0"]) {
                    
                    if (groupText.length>0) {
                        
                        querySQL = [NSString stringWithFormat:
                                    @"SELECT tp.*, t.is_favourite, t.logoID\
                                    FROM teams t,team_positions tp\
                                    LEFT OUTER JOIN sub_league sl ON sl.id=tp.league_id\
                                    WHERE sl.league_id=%@\
                                    AND t.id=tp.teams_id\
                                    AND t.league_id=tp.league_id\
                                    AND tp.logoID='%@'\
                                    GROUP BY tp.id \
                                    ORDER BY tp.position ASC", leagueID, groupText];
                        
                    } else {
                        
                        querySQL = [NSString stringWithFormat:
                                    @"SELECT tp.*, t.is_favourite, t.logoID\
                                    FROM teams t,team_positions tp\
                                    LEFT OUTER JOIN sub_league sl ON sl.id=tp.league_id\
                                    WHERE sl.league_id=%@\
                                    AND t.id=tp.teams_id\
                                    AND t.league_id=tp.league_id\
                                    GROUP BY tp.id \
                                    ORDER BY tp.position ASC", leagueID];
                    }
                }
            }
            
            
        }
        
        sqlite3_finalize(statement);
        
        
        query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* fa = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = fa == NULL ? nil : [[NSString alloc] initWithUTF8String:fa];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
                
                
            }
            
        }
    }
    
    
    
    sqlite3_finalize(statement);
    
    const char *query_stmt;
    
    //Here we do a count of our results. If it is zero and subleagues are not equal to zero then we run the default query searching by league id instead of subleague id
    
    if (resultArray.count ==0 && ![subleagueCount isEqualToString:@"0"]) {
        
        query_stmt = [[NSString stringWithFormat:
                       @"SELECT tp.*, t.is_favourite, t.logoID FROM team_positions tp, teams t  WHERE tp.league_id='%@' AND t.id=tp.teams_id AND t.league_id=tp.league_id GROUP BY tp.id ORDER BY tp.position ASC", leagueID] UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                const char* fa = (const char*)sqlite3_column_text(statement, 28);
                NSString *logoID = fa == NULL ? nil : [[NSString alloc] initWithUTF8String:fa];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", logoID, @"logoID", nil];
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

- (NSMutableArray *)getFavouritesInLeagueTableForTempSaving {
    
    [self getDB];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT id, league_id FROM teams WHERE is_favourite = 'Y'"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *leagueID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", leagueID, @"league_id", nil];
                
                [resultArray addObject:dict];
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

- (NSMutableArray *)getFavouritesInLeagueTable {
    
    [self getDB];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
    
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT tp.*, t.is_favourite, l.name\
                              FROM teams t,team_positions tp, league l\
                              LEFT OUTER JOIN sub_league sl ON (sl.league_id=l.id)\
                              WHERE t.is_favourite='Y'\
                              AND t.id=tp.teams_id\
                              AND t.league_id = tp.league_id\
                              AND (sl.id = t.league_id OR l.id = t.league_id)\
                              GROUP BY tp.id, tp.league_id\
                              ORDER BY tp.position ASC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSDictionary *dict = [NSDictionary new];
                
                NSString *row_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *league_id = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teams_id = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *team_name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *position = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *points = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_home_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *team_away_points = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *total_played_amount = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *total_win = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *total_draw = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                
                NSString *total_lose = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 11)];
                
                NSString *total_goals_for = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 12)];
                
                NSString *total_goals_against = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 13)];
                
                NSString *goal_difference = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 14)];
                
                NSString *home_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                
                NSString *home_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 16)];
                
                NSString *home_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 17)];
                
                NSString *home_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 18)];
                
                NSString *home_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 19)];
                
                NSString *away_win = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                
                NSString *away_draw = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 21)];
                
                NSString *away_lose = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 22)];
                
                NSString *away_total_goals_for = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 23)];
                
                NSString *away_total_goals_against = [[NSString alloc] initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 24)];
                
                NSString *date_updated = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 25)];
                
                NSString *is_favourite = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 27)];
                
                NSString *league_name = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 28)];
                
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:row_id, @"row_id", league_id, @"league_id", teams_id, @"team_id", team_name, @"team_name", position,@"position",team_home_points,@"team_home_points",team_away_points,@"team_away_points", total_win, @"total_win", total_draw, @"total_draw", total_goals_for, @"total_goals_for", total_goals_against, @"total_goals_against", goal_difference, @"goal_difference", home_win, @"home_win", total_played_amount, @"total_played_amount", total_lose, @"total_lose", home_draw, @"home_draw", home_lose, @"home_lose", home_total_goals_for, @"home_total_goals_for", home_total_goals_against, @"home_total_goals_against", away_win, @"away_win", away_lose, @"away_lose", away_total_goals_for, @"away_total_goals_for",away_total_goals_against, @"away_total_goals_against", away_draw, @"away_draw", points, @"total_points", date_updated, @"date_added", is_favourite, @"is_favourite", @"", @"logoID", league_name, @"league_name", nil];
                
                [resultArray addObject:dict];

                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(int)amountOfGoalsFor:(NSString *)teamID {
    
    [self getDB];
    
    int totalScore =0;

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT team_home_score FROM fixtures WHERE teams_home_id = %@", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 0)];
                
                
                totalScore = totalScore + [teamHomeScore intValue];
            }
            
            totalScore = totalScore + [self amountOfGoalsAway:teamID];
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (totalScore != 0) {
        
        return totalScore;
        
    } else {
        
        return 0;
        
    }
    
}


-(int)amountOfGoalsAway:(NSString *)teamID {
    
    [self getDB];
    
    int totalScore =0;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT team_away_score FROM fixtures WHERE teams_away_id = %@", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                
                
                totalScore = totalScore + [teamHomeScore intValue];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (totalScore != 0) {
        
        return totalScore;
        
    } else {
        
        return 0;
        
    }
    
}

-(int)goalsAgainst:(NSString *)teamID {
    
    [self getDB];
    
    int totalScore =0;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT team_away_score FROM fixtures WHERE teams_home_id = %@", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                
                
                totalScore = totalScore + [teamHomeScore intValue];
            }
            
            totalScore = totalScore + [self amountOfGoalsAway:teamID];
            
                    }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (totalScore != 0) {
        
        return totalScore;
        
    } else {
        
        return 0;
        
    }
    
    
}


-(int)goalsAgainstAway:(NSString *)teamID {
    
    [self getDB];
    int totalScore =0;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT team_home_score FROM fixtures WHERE teams_away_id = %@", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                
                
                totalScore = totalScore + [teamHomeScore intValue];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (totalScore != 0) {
        
        return totalScore;
        
    } else {
        
        return 0;
        
    }
    
}


-(int)getPointsForTeam:(NSString *)teamID {
    
    [self getDB];
    int totalScore =0;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT points FROM team_positions WHERE teams_id = %@", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                
                
                totalScore = totalScore + [teamHomeScore intValue];
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (totalScore != 0) {
        
        return totalScore;
        
    } else {
        
        return 0;
        
    }
    
}

- (NSMutableArray *)getLast5GameWinsLoosesDraw:(NSString *)teamID leagueID:(NSString *)leagueID{
    
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    [self getDB];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];

    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT f.id,\
                              ( CASE\
                               WHEN ( `team_home_score` > team_away_score\
                                     AND teams_home_id = t.id )\
                               OR ( team_away_score > team_home_score\
                                   AND teams_away_id = t.id ) THEN 'WON'\
                               WHEN ( `team_home_score` < team_away_score\
                                     AND teams_home_id = t.id )\
                               OR ( team_away_score < team_home_score\
                                   AND teams_away_id = t.id ) THEN 'LOST'\
                               WHEN ( `team_home_score` = team_away_score\
                                     AND teams_home_id = t.id )\
                               OR ( team_away_score = team_home_score\
                                   AND teams_away_id = t.id ) THEN 'DRAW'\
                               end ) AS game_result\
                              FROM   teams t,\
                              fixtures f\
                              \
                              LEFT OUTER JOIN sub_league sl\
                              ON sl.id=f.league_id\
                              WHERE (sl.id = %@ OR f.league_id = %@ OR sl.league_id = %@)\
                              \
                              AND  t.id = %@\
                              AND (f.status = 'Fin' OR f.status='1 HF' OR f.status = '2 HF')\
                              AND ( f.teams_home_id = %@\
                                   OR f.teams_away_id = %@ )\
                              AND f.fixture_date < '%@ 00:00:00'\
                              GROUP  BY f.id\
                              ORDER  BY f.fixture_date DESC\
                              LIMIT  5", leagueID, leagueID, leagueID, teamID, teamID, teamID, today];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dict = [NSDictionary new];
                
                NSString *matchID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *wonLostDrew = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)];
                
                dict = [[NSDictionary alloc] initWithObjectsAndKeys:wonLostDrew, @"wonLostDrew", matchID, @"matchID", nil];
                
                [resultArray addObject:dict];
                
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}


- (NSMutableArray *)getListOfAllPlayers {
    
    [self getDB];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM players"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *firstName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *lastName = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 2)];
                
                
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:playerID, @"playerID", firstName, @"firstName", lastName, @"lastName", nil];
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
}

- (NSString *)getPlayersCurrentTeam:(NSString *)playerID {
    
    [self getDB];
    
    NSString *theCurrentTeamName = nil;
    int teamID = 0;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT teams_id FROM player_team_map WHERE players_id = %@ AND current_team = 'Y' LIMIT 1", playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                
                
                teamID = [teamName intValue];
                
                
            }
        }
        
        
        NSString *querySQL2 = querySQL2  = [NSString stringWithFormat:
                                          @"SELECT name FROM teams where id = '%d'", teamID];
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt2, -1, &statement, NULL) == SQLITE_OK)
        {

            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                
                theCurrentTeamName = teamName;
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (theCurrentTeamName != nil) {
        
        return theCurrentTeamName;
        
    } else {
        
        return nil;
        
    }
}


-(NSMutableArray *)listOfTeams {
    
    [self getDB];
    
    NSMutableArray *teamsIDArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT id, name FROM teams"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];

                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:teamID, @"teamID", teamName, @"teamName", nil];
                
                [teamsIDArray addObject:teamDict];
                
                
            }
        }
    }

    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (teamsIDArray != nil) {
        
        return teamsIDArray;
        
    } else {
    
    return nil;
        
    }
}


-(NSMutableArray *)playerTeamRelationship {

    [self getDB];
    
    NSMutableArray *teamsIDArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT teams_id, players_id FROM player_team_map WHERE current_team = 'Y'"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:teamID, @"teamID", playerID, @"playerID", nil];
                
                [teamsIDArray addObject:teamDict];
                
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (teamsIDArray != nil) {
        
        return teamsIDArray;
        
    } else {
        
        return nil;
        
    }

    return nil;
}

-(NSMutableArray *)getPlayerDetails:(NSString *)playerID {
    
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT p.id, p.name, t.name, t.id FROM players p, teams t WHERE p.id = '%@' AND t.id=p.team_id GROUP BY p.name", playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *thePlayerID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 2)];

                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:thePlayerID, @"player_id", name, @"name", teamID, @"team_id", teamName, @"team_name", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }

    
    
}


-(NSMutableArray *)getTeamsPerLeague:(NSString *)leagueID {
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT teams_id from team_positions WHERE league_id = '%@'", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)  {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:leagueID, @"leagueID", teamID, @"teamID", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
        
        
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }

}


-(NSMutableArray *)getTeamsPerLeagueAndHaveNameReturned:(NSString *)leagueID {
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
    
        NSString *querySQL = [NSString stringWithFormat:@"SELECT fpv.team_id, fpv.team_name, fpv.league_id\
                              FROM form_players_view fpv\
                              LEFT OUTER JOIN sub_league sl\
                              ON (sl.id=fpv.league_id)\
                              WHERE (sl.id=%@ OR fpv.league_id=%@ OR sl.league_id=%@)\
                              GROUP BY fpv.team_id", leagueID, leagueID, leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
           
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *leagueID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSDictionary *teamDict = @{@"leagueID": leagueID, @"teamID":teamID, @"teamName":teamName};
                [resultsArray addObject:teamDict];
            
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"teamName" ascending:true];
        NSArray *sa = [resultsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        resultsArray = [sa mutableCopy];
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getLastGames:(NSString *)teamID amountOfGames:(NSString *)gameAmount theDate:(NSString *)date {
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM fixtures WHERE teams_home_id = '%@' OR teams_away_id = '%@' AND fixture_date < '%@' ORDER BY fixture_date ASC LIMIT %@", teamID, teamID, date, gameAmount];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *fixtureID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamsHomeID = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *teamAwayId = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *teamsAwayScore = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 7)];

                
                NSString *leagueID = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 13)];

                
                NSString *isHome = nil;
                
                if ([teamsHomeID isEqualToString:teamID]) {
                    isHome = @"YES";
                } else {
                    isHome = @"NO";
                }
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:fixtureID, @"fixtureID", teamsHomeID, @"teamHomeID", teamAwayId, @"teamAwayID", isHome, @"isHome", fixtureDate, @"fixtureDate", leagueID, @"leagueID", teamHomeScore, @"homeScore", teamsAwayScore, @"awayScore",  nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getLastGamesHome:(NSString *)teamID amountOfGames:(NSString *)gameAmount theDate:(NSString *)date {
 
    [self getDB];
 
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
 
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM fixtures WHERE teams_home_id = '%@' AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamID, date, gameAmount];
 
        const char *query_stmt = [querySQL UTF8String];
 
 
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
 
                NSString *fixtureID = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamsHomeID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamsAwayID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *leagueID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *isCupGame = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *homeScore = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *awayScore = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *isHome = nil;
                
                if ([teamsHomeID isEqualToString:teamID]) {
                    isHome = @"YES";
                } else {
                    isHome = @"NO";
                }
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:fixtureID, @"fixtureID", teamsHomeID, @"teamHomeID", teamsAwayID, @"teamAwayID", isHome, @"isHome", fixtureDate, @"fixtureDate", leagueID, @"leagueID", isCupGame, @"isCupGame", homeScore, @"homeScore", awayScore, @"awayScore", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSMutableArray *)getLastGamesAway:(NSString *)teamID amountOfGames:(NSString *)gameAmount theDate:(NSString *)date {
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM fixtures WHERE teams_away_id = '%@' AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamID, date, gameAmount];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *fixtureID = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamsHomeID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamsAwayID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *leagueID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *isCupGame = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *homeScore = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *awayScore = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *isHome = nil;
                
                if ([teamsHomeID isEqualToString:teamID]) {
                    isHome = @"YES";
                } else {
                    isHome = @"NO";
                }
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:fixtureID, @"fixtureID", teamsHomeID, @"teamHomeID", teamsAwayID, @"teamAwayID", isHome, @"isHome", fixtureDate, @"fixtureDate", leagueID, @"leagueID", isCupGame, @"isCupGame", homeScore, @"homeScore", awayScore, @"awayScore", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
}

-(void)updateFavourites:(NSString *)yOrN teamName:(NSString *)teamName {
    
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL;
        NSString *lID = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];

        if ([yOrN isEqualToString:@"Y"]) {
            
            querySQL  = [NSString stringWithFormat:
                         @"UPDATE teams SET is_favourite = ? WHERE id = ? AND league_id = ?"];

        } else {
            
            querySQL  = [NSString stringWithFormat:
                                          @"UPDATE teams SET is_favourite = ? WHERE id = ?"];
            
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(placesDB));

        } else {
            
            sqlite3_bind_text(statement, 1, [yOrN UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [teamName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [lID UTF8String], -1, SQLITE_TRANSIENT);

            if(sqlite3_step(statement) != SQLITE_DONE) {
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
}

-(void)updateFavouritesWithLeague:(NSString *)yOrN teamName:(NSString *)teamName lid:(NSString *)lid{
    
    [self getDB];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL;
        
        if ([yOrN isEqualToString:@"Y"]) {
            
            querySQL  = [NSString stringWithFormat:
                         @"UPDATE teams SET is_favourite = ? WHERE id = ? AND league_id = ?"];
            
        } else {
            
            querySQL  = [NSString stringWithFormat:
                         @"UPDATE teams SET is_favourite = ? WHERE id = ? AND league_id = ?"];
            
        }

        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(placesDB));
            
        } else {
            
            sqlite3_bind_text(statement, 1, [yOrN UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [teamName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [lid UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(statement) != SQLITE_DONE) {
                
            }
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
}

-(NSMutableArray *)getGamesForHomeTeam:(NSString *)teamsHomeId {

    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT team_home_score, team_away_score FROM fixtures WHERE teams_home_id = '%@'", teamsHomeId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *team_home_score = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *team_away_score = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 1)];
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:team_home_score, @"team_home_score", @"3", team_away_score, nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)statsExplorerGetGamesForHomeTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames lid:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        /*
        NSString *querySQL = [NSString stringWithFormat:@"SELECT team_home_score, team_away_score, fixture_date, teams_home_id, teams_away_id, teams_home_name, teams_away_name, f.id\
                               FROM fixtures f\
                               LEFT OUTER JOIN sub_league sl\
                               ON sl.id=f.league_id\
                               \
                               WHERE teams_home_id=%@\
                               AND (sl.id = %@ OR sl.league_id=%@ OR f.league_id=%@)\
                               \
                               AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamsHomeId, lid, lid, lid, today, amountOfGames];
         */
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT team_home_score, team_away_score, fixture_date, teams_home_id, teams_away_id, teams_home_name, teams_away_name, f.id\
                              FROM fixtures f\
                              WHERE teams_home_id=%@\
                              AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamsHomeId, today, amountOfGames];

        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *team_home_score = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *team_away_score = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *team_home_id = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *team_away_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *team_home_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_away_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *fixtureID = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 7)];

                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:team_home_score, @"team_home_score", team_away_score, @"team_away_score", team_home_id, @"team_home_id", team_away_id, @"team_away_id", team_home_name, @"team_home_name", team_away_name, @"team_away_name", fixtureID, @"fixture_id", nil];
                
                [resultsArray addObject:teamDict];
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)statsExplorerGetGamesForAwayTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames lid:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        /*
        NSString *querySQL = [NSString stringWithFormat:@"SELECT team_home_score, team_away_score, fixture_date, teams_home_id, teams_away_id, teams_home_name, teams_away_name, f.id\
                              FROM fixtures f\
                              LEFT OUTER JOIN sub_league sl\
                              ON sl.id=f.league_id\
                              \
                              WHERE teams_away_id=%@\
                              AND (sl.id = %@ OR sl.league_id=%@ OR f.league_id=%@)\
                              \
                              AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamsHomeId, lid, lid, lid, today, amountOfGames];
        */
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT team_home_score, team_away_score, fixture_date, teams_home_id, teams_away_id, teams_home_name, teams_away_name, f.id\
                              FROM fixtures f\
                              WHERE teams_away_id=%@\
                              AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamsHomeId, today, amountOfGames];

        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *team_home_score = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *team_away_score = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *team_home_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *team_away_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *team_home_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_away_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *fixtureID = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 7)];

                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:team_home_score, @"team_home_score", team_away_score, @"team_away_score", team_home_id, @"team_home_id", team_away_id, @"team_away_id", team_home_name, @"team_home_name", team_away_name, @"team_away_name", fixtureID, @"fixture_id", nil];
                
                [resultsArray addObject:teamDict];
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
}

-(NSMutableArray *)statsExplorerGetGamesForBothTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames lid:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        /* THIS IS WITH LEAGUE ID
        NSString *querySQL = [NSString stringWithFormat:@"SELECT team_home_score, team_away_score, fixture_date, teams_home_id, teams_away_id, teams_home_name, teams_away_name, f.id\
                              FROM fixtures f\
                              LEFT OUTER JOIN sub_league sl\
                              ON sl.id=f.league_id\
                              \
                              WHERE (teams_home_id = %@ OR teams_away_id=%@)\
                              AND (sl.id = %@ OR sl.league_id=%@ OR f.league_id=%@)\
                              \
                              AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamsHomeId, teamsHomeId, lid, lid, lid, today, amountOfGames];

         */
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT team_home_score, team_away_score, fixture_date, teams_home_id, teams_away_id, teams_home_name, teams_away_name, f.id\
                              FROM fixtures f\
                              WHERE (teams_home_id = %@ OR teams_away_id=%@)\
                              AND fixture_date < '%@' ORDER BY fixture_date DESC LIMIT %@", teamsHomeId, teamsHomeId, today, amountOfGames];

        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *team_home_score = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *team_away_score = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *team_home_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *team_away_id = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *team_home_name = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *team_away_name = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *fixID = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 7)];
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:team_home_score, @"team_home_score", team_away_score, @"team_away_score", team_home_id, @"team_home_id", team_away_id, @"team_away_id", team_home_name, @"team_home_name", team_away_name, @"team_away_name", fixID, @"fixture_id", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSString *)getTeamPositionInLeagueTable:(NSString *)teamID {
    
    [self getDB];
    
    NSString *pos;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT position FROM team_positions WHERE teams_id = '%@'", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                pos = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];

                

            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (pos != nil) {
        
        return pos;
        
    } else {
        
        return nil;
        
    }
    
    
}

-(NSString *)getPlayerNameFromID:(NSString *)playerID {
    
    [self getDB];
    
    NSString *name;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT name FROM players WHERE id ='%@'", playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                name = [[NSString alloc] initWithUTF8String:
                       (const char *) sqlite3_column_text(statement, 0)];
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (name != nil) {
        
        return name;
        
    } else {
        
        return nil;
        
    }

    
}

-(NSString *)getLeagueBackFromTeamID:(NSString *)teamID {
    
    [self getDB];
    
    NSString *name;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT t.league_id, l.name \
                                          FROM teams t, league l \
                                          WHERE t.id='%@' AND l.id = t.league_id", teamID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                name = [[NSString alloc] initWithUTF8String:
                        (const char *) sqlite3_column_text(statement, 1)];
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (name != nil) {
        
        return [name capitalizedString];
        
    } else {
        
        return nil;
        
    }
}


-(NSMutableArray *)getYellowCardsFromMatchID:(NSString *)matchID{
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM yellow_cards WHERE match_id='%@' AND (type='Yellow' OR type='Yellow/Red')", matchID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *cardID = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *playerName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *timePlayerGotCard = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *recAt = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement,6)];
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:cardID, @"id", teamID, @"teamID", playerID, @"playerID", playerName, @"playerName", timePlayerGotCard, @"timePlayerGotCard", recAt, @"recieved_at", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getRedCardsFromMatchID:(NSString *)matchID{
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT * FROM yellow_cards WHERE match_id='%@' AND (type='Red' OR type='Yellow/Red')", matchID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *cardID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *playerName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *timePlayerGotCard = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *recAt = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement,6)];
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:cardID, @"id", teamID, @"teamID", playerID, @"playerID", playerName, @"playerName", timePlayerGotCard, @"timePlayerGotCard", recAt, @"recieved_at", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSString *)getPlayersTotalGoals:(NSString *)playerID leagueID:(NSString *)leagueID {
    
    [self getDB];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT COUNT(*) FROM goals_scored gs, fixtures f\
                                          WHERE gs.player_id='%@'\
                                          AND gs.match_id=f.id\
                                          AND f.league_id=%@", playerID, leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                goalsScoredCount = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSString *)getPlayersTotalGoalsHomeAway:(NSString *)playerID homeAway:(NSString *)homeAway {
    
    [self getDB];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT COUNT(*) FROM goals_scored WHERE player_id='%@' AND team_side='%@'", playerID, homeAway];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                goalsScoredCount = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSString *)getAverageScoreTimeWithPlayerID:(NSString *)playerID{
    
    [self getDB];
    
    NSString *avgTime;
    
    NSMutableArray *time = [[NSMutableArray alloc]init];

    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT time_scored_in FROM goals_scored WHERE player_id='%@'", playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *timeScoredIn = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                [time addObject:timeScoredIn];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    
    if ([time count]==0) {
        
        return @"N/A";
        
    } else {
        
        int total =0;
        
        for (NSString *tim in time) {
            total = total + [tim intValue];
        }
        
        avgTime = [NSString stringWithFormat:@"%lu", total / [time count]];
    }
    
    if (avgTime != nil) {
        
        return avgTime;
        
    } else {
        
        return @"N/A";
        
    }
    
}


-(NSString *)getAverageCardTimeWithPlayerID:(NSString *)playerID {
    
    [self getDB];
    
    NSString *avgTime;
    
    NSMutableArray *time = [[NSMutableArray alloc]init];
    
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT time_player_got_card FROM yellow_cards WHERE player_id='%@'", playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *timeScoredIn = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                
                [time addObject:timeScoredIn];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    
    if ([time count]==0) {
        
        return @"N/A";
        
    } else {
        
        int total =0;
        
        for (NSString *tim in time) {
            total = total + [tim intValue];
        }
        
        avgTime = [NSString stringWithFormat:@"%lu", total / [time count]];
    }
    
    if (avgTime != nil) {
        
        return avgTime;
        
    } else {
        
        return @"N/A";
        
    }
    
}


-(NSString *)getPlayersTotalCards:(NSString *)playerID colour:(NSString *)redOrYellow leagueID:(NSString *)leagueID {
    
    [self getDB];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT COUNT(*) FROM yellow_cards yc, fixtures f\
                                          WHERE yc.player_id='%@'\
                                          AND f.id=yc.match_id\
                                          AND f.league_id=%@\
                                          AND (yc.type = '%@' OR yc.type ='Yellow/Red')", playerID, leagueID, redOrYellow];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                goalsScoredCount = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return nil;
        
    }
}

-(NSString *)getTotalGoalsPerXGamesWithGameAmount:(NSString *)limit andPlayerID:(NSString *)playerID leagueID:(NSString *)leagueID {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL  = [NSString stringWithFormat:
                                          @"SELECT Count(gs.id)\
                                          FROM   goals_scored gs\
                                          INNER JOIN (SELECT f2.id,\
                                          f2.fixture_date \
                                          FROM   fixtures f2, line_ups lu \
                                          WHERE  f2.fixture_date <= '%@ 00:00:00' \
                                          AND f2.id=lu.match_id \
                                          AND f2.league_id=%@\
                                          AND lu.player_id=%@ \
                                          ORDER  BY f2.fixture_date DESC \
                                          LIMIT  %@) AS f \
                                          ON ( f.id = gs.match_id) \
                                          WHERE gs.player_id=%@",today, leagueID, playerID, limit, playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char* GSC = (const char*)sqlite3_column_text(statement, 0);

                goalsScoredCount = GSC == NULL ? nil : [[NSString alloc] initWithUTF8String:GSC];

                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return @"0";
        
    }
    
}



-(NSString *)getTotalGoalsPerXGamesWithGameAmountHome:(NSString *)limit andPlayerID:(NSString *)playerID leagueID:(NSString *)leagueID {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT Count(gs.id)\
                                          FROM   goals_scored gs\
                                          INNER JOIN (SELECT f2.id,\
                                                      f2.fixture_date \
                                                      FROM   fixtures f2, line_ups lu \
                                                      WHERE  f2.fixture_date <= '%@ 00:00:00' \
                                                      AND f2.`teams_home_id` = lu.team_id \
                                                      AND f2.id=lu.match_id \
                                                      AND f2.league_id=%@\
                                                      AND lu.player_id=%@ \
                                                      ORDER  BY f2.fixture_date DESC \
                                                      LIMIT  %@) AS f \
                                          ON ( f.id = gs.match_id) \
                                          WHERE gs.player_id=%@",today, leagueID, playerID, limit, playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char* GSC = (const char*)sqlite3_column_text(statement, 0);
                
                goalsScoredCount = GSC == NULL ? nil : [[NSString alloc] initWithUTF8String:GSC];
                
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return @"0";
        
    }
    
}


-(NSString *)getTotalGoalsPerXGamesWithGameAmountAway:(NSString *)limit andPlayerID:(NSString *)playerID leagueID:(NSString *)leagueID {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT Count(gs.id)\
                                          FROM   goals_scored gs\
                                          INNER JOIN (SELECT f2.id,\
                                          f2.fixture_date \
                                          FROM   fixtures f2, line_ups lu \
                                          WHERE  f2.fixture_date <= '%@ 00:00:00' \
                                          AND f2.`teams_away_id` = lu.team_id \
                                          AND f2.id=lu.match_id \
                                          AND f2.league_id=%@\
                                          AND lu.player_id=%@ \
                                          ORDER  BY f2.fixture_date DESC \
                                          LIMIT  %@) AS f \
                                          ON ( f.id = gs.match_id) \
                                          WHERE gs.player_id=%@",today, leagueID, playerID, limit, playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char* GSC = (const char*)sqlite3_column_text(statement, 0);
                
                goalsScoredCount = GSC == NULL ? nil : [[NSString alloc] initWithUTF8String:GSC];
                
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return @"0";
        
    }
    
}



-(NSString *)getTotalCardsPerXGamesWithGameAmount:(NSString *)limit andPlayerID:(NSString *)playerID cardColour:(NSString *)redOrYellow leagueID:(NSString *)leagueID {

    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT COUNT(gs.id) FROM yellow_cards gs INNER JOIN ( SELECT f2.id, f2.fixture_date FROM fixtures f2 WHERE f2.fixture_date <= '%@ 00:00:00' AND f2.league_id=%@ AND (f2.`teams_away_id` = (SELECT team_id FROM players WHERE id = %@) OR f2.teams_home_id = (SELECT team_id FROM players WHERE id = %@)) GROUP BY f2.id ORDER BY f2.fixture_date DESC LIMIT %@ ) as f ON (f.id = gs.match_id) AND gs.player_id = %@ AND (gs.type='%@' OR gs.type='Yellow/Red')",today,leagueID, playerID,playerID,limit,playerID, redOrYellow];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char* GSC = (const char*)sqlite3_column_text(statement, 0);
                
                goalsScoredCount = GSC == NULL ? nil : [[NSString alloc] initWithUTF8String:GSC];
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return @"0";
        
    }
    
}

-(NSString *)getAverageGoalScoreTimePerGame:(NSString *)limit andPlayerID:(NSString *)playerID {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT AVG(gs.time_scored_in), COUNT(gs.id)\
                                          FROM   goals_scored gs\
                                          INNER JOIN (SELECT f2.id,\
                                          f2.fixture_date \
                                          FROM   fixtures f2, line_ups lu \
                                          WHERE  f2.fixture_date <= '%@ 00:00:00' \
                                          AND f2.`teams_home_id` = lu.team_id \
                                          AND f2.id=lu.match_id \
                                          AND lu.player_id=%@ \
                                          ORDER  BY f2.fixture_date DESC \
                                          LIMIT  %@) AS f \
                                          ON ( f.id = gs.match_id) \
                                          WHERE gs.player_id=%@",today, playerID, limit, playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char* GSC = (const char*)sqlite3_column_text(statement, 0);
                
                goalsScoredCount = GSC == NULL ? nil : [[NSString alloc] initWithUTF8String:GSC];
                
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return @"N/A";
        
    }
    
}

-(NSString *)getAverageTimeCardRecievedPerGame:(NSString *)limit andPlayerID:(NSString *)playerID {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSString *goalsScoredCount;
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT AVG(gs.time_player_got_card), COUNT(gs.id) FROM yellow_cards gs INNER JOIN ( SELECT f2.id, f2.fixture_date FROM fixtures f2 WHERE f2.fixture_date <= '%@ 00:00:00' AND (f2.`teams_away_id` = (SELECT team_id FROM players WHERE id = %@) OR f2.teams_home_id = (SELECT team_id FROM players WHERE id = %@)) GROUP BY f2.id ORDER BY f2.fixture_date DESC LIMIT %@ ) as f ON (f.id = gs.match_id) AND gs.player_id = %@",today, playerID, playerID, limit, playerID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char* GSC = (const char*)sqlite3_column_text(statement, 0);
                
                goalsScoredCount = GSC == NULL ? nil : [[NSString alloc] initWithUTF8String:GSC];
                
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (goalsScoredCount != nil) {
        
        return goalsScoredCount;
        
    } else {
        
        return @"N/A";
        
    }
    
}



-(NSMutableArray *)getPlayerTotalGoalsPerPhase:(NSString *)period ascOrDesc:(NSString *)ascOrDesc {
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @" SELECT t.id AS TeamId, p.id AS PlayerId, p.name, gs.time_scored_in, gs.period, count(gs.id), t.name, l.name FROM league l, teams t, players p, goals_scored gs WHERE l.should_show_on_app='Y' AND l.name != 'FA COMMUNITY SHIELD' AND l.name != 'FA CUP' AND t.league_id=l.id AND p.team_id=t.id AND p.id=gs.player_id AND gs.period=%@ GROUP BY gs.player_id ORDER BY count(gs.id) %@", period, ascOrDesc];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *playerName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *timeScoredIn = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *Periody = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *TotalGoals = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement,5)];
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement,6)];
                
                NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement,7)];

                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:teamID, @"teamID", playerID, @"playerID", playerName, @"playerName", timeScoredIn, @"timeScoredIn", Periody, @"period", TotalGoals, @"TotalGoals", [teamName capitalizedString], @"teamName", [leagueName capitalizedString], @"leagueName", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getFormPlayers:(NSString *)leagueID side:(NSString *)side {
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *type = @"0";
        
        if ([side isEqualToString:@"HOME"]) {
            type = @"1";
        } else if ([side isEqualToString:@"AWAY"]) {
            type = @"2";
        }
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT fpv.player_id, fpv.player_name, fpv.team_name, fpv.team_id, fpv.p1_goals, fpv.p2_goals, fpv.appearances, fpv.type FROM form_players_view fpv\
                              LEFT OUTER JOIN sub_league as sl\
                              ON (sl.id=fpv.league_id)\
                              WHERE (sl.id = %@ OR fpv.league_id = %@ OR sl.league_id = %@)\
                              AND fpv.type=%@\
                              AND (fpv.p1_goals > 0 OR fpv.p2_goals > 0)\
                              GROUP BY fpv.player_id", leagueID, leagueID, leagueID, type];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *playerName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *periodOneGoals = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *periodTwoGoals = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *appearances = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *totalGoals = [NSString stringWithFormat:@"%d", [periodOneGoals intValue]+[periodTwoGoals intValue]];
                
                NSString *sortBy = [NSString stringWithFormat:@"%d", [totalGoals intValue]/[appearances intValue]];
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:teamID, @"teamID", playerID, @"playerID", playerName, @"playerName", periodOneGoals, @"periodOneGoals", periodTwoGoals, @"periodTwoGoals", totalGoals, @"TotalGoals", [teamName capitalizedString], @"teamName", appearances, @"appearances", sortBy, @"sortBy", @"", @"logoID", nil];
                
                if(![resultsArray containsObject:teamDict]) [resultsArray addObject:teamDict];
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getLineUpsPerMatchID:(NSString *)matchID {
    
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT p.id AS playerID, p.name AS playerName, l.team_id AS teamid FROM line_ups l, players p WHERE match_id = %@ AND p.id=l.player_id GROUP BY p.id ORDER BY teamid ASC", matchID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *playerID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *playerName = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamID = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:playerID, @"playerID", playerName, @"playerName", teamID, @"teamID", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }

}


-(NSMutableArray *)getHomeOrAwayFixtures:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [NSDate date];
    NSDate *yesterdy = [today dateByAddingTimeInterval: -86400.0];
    NSString *yesterday  = [outputDateFormatter stringFromDate:yesterdy];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT t.id AS teamid, f.id AS fixtureID, f.teams_home_id, f.teams_home_name, f.team_home_score, f.teams_away_id, f.teams_away_name, f.team_away_score, f.fixture_date, f.start_time FROM teams t, fixtures f WHERE t.league_id=%@ AND f.teams_home_id=t.id AND f.fixture_date < '%@' ORDER BY f.fixture_date DESC", lid, yesterday];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamid = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *fixtureid = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamHomeID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *teamHomeName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 3)];

                
                NSString *teamHomeScore = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 4)];

                
                NSString *teams_away_id = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 5)];

                
                NSString *teams_away_name = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 6)];

                
                NSString *team_away_score = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 7)];

                
                NSString *fixture_date = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 8)];

                
                NSString *startTime = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 9)];

                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:teamid, @"teamID", fixtureid, @"fixtureID", teamHomeID, @"teamHomeID", teamHomeName, @"teamHomeName", teamHomeScore, @"teamHomeScore", teams_away_id, @"teamAwayID", teams_away_name, @"teamsAwayName", team_away_score, @"teamAwayScore", fixture_date, @"fixtureDate", startTime, @"startTime", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSMutableArray *)getTeamIDPerFixtureViaLeague:(NSString *)lid {
    
    
    [self getDB];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [NSDate date];
    NSDate *yesterdy = [today dateByAddingTimeInterval: -86400.0];
    NSString *yesterday  = [outputDateFormatter stringFromDate:yesterdy];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT t.id AS teamid, f.id AS fixtureID, f.teams_home_id, f.teams_home_name FROM teams t, fixtures f WHERE t.league_id=%@ AND f.teams_home_id=t.id AND f.fixture_date < '%@' GROUP BY f.teams_home_id  ORDER BY f.fixture_date DESC", lid, yesterday];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *teamid = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *fixtureid = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *teamHomeID = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *teamHomeName = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 3)];
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:teamid, @"teamID", fixtureid, @"fixtureID", teamHomeID, @"teamHomeID", teamHomeName, @"teamHomeName", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}

-(NSMutableArray *)getSubLeagues {
    
    [self getDB];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *lid = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT id, name, comp_start, comp_end, league_id FROM sub_league WHERE league_id=%@ ORDER BY sort ASC", lid];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *slid = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *start = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *end = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *lid = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 4)];
                
                NSDictionary *teamDict = @{@"id": slid, @"name":name, @"start":start, @"end":end, @"league_id":lid};
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSMutableArray *)getLastAvailableGamesPerLeague:(NSString *)lid {
    
    /*
    NSMutableArray *entireArray = [NSMutableArray new];
    
    //NSMutableArray *previousGames = [self getLast5PreviousGames:lid];
    NSMutableArray *futureGames = [self getNext5Games:lid];
    NSMutableArray *prevGames = [self getLast5PreviousGames:lid];
    //Here i'm reversing it as it's coming back in the wrong order for previous games
    
    NSMutableArray *allGames = [self getAllFixturesForLeague:lid];
    
    NSArray* reversed = [[prevGames reverseObjectEnumerator] allObjects];
    
    for (NSDictionary *dict in reversed) {
        
        NSString *date = [dict objectForKey:@"date"];
        
        date = [date stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *datey = [dateFormatter dateFromString:date];
        dateFormatter.dateFormat=@"EEEE";
        NSString * dayString = [[dateFormatter stringFromDate:datey] capitalizedString];
        dateFormatter.dateFormat=@"dd";
        NSString * daypos = [[dateFormatter stringFromDate:datey] capitalizedString];
        dateFormatter.dateFormat=@"MMM";
        NSString * monthString = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        dateFormatter.dateFormat=@"yyyy";
        NSString * yearString = [[dateFormatter stringFromDate:datey] capitalizedString];

        
        NSString *dString = [NSString stringWithFormat:@"%@ %@ %@ %@",dayString, [self addSuffixToNumber:[daypos intValue]], monthString, yearString];
        NSDictionary *dicty = [[NSDictionary alloc]initWithObjectsAndKeys:date, @"date", dString, @"dateName", nil];
        
        if (![entireArray containsObject:dicty]) {
            
            [entireArray addObject:dicty];
        }
        
    }
    
    for (NSDictionary *dict in futureGames) {
        
        NSString *date = [dict objectForKey:@"date"];
        
        date = [date stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *datey = [dateFormatter dateFromString:date];
        
        dateFormatter.dateFormat=@"EEEE";
        NSString * dayString = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        dateFormatter.dateFormat=@"dd";
        NSString * daypos = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        dateFormatter.dateFormat=@"MMM";
        NSString * monthString = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        dateFormatter.dateFormat=@"yyyy";
        NSString * yearString = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        NSString *dString = [NSString stringWithFormat:@"%@ %@ %@ %@",dayString, [self addSuffixToNumber:[daypos intValue]], monthString, yearString];
        NSDictionary *dicty = [[NSDictionary alloc]initWithObjectsAndKeys:date, @"date", dString, @"dateName", nil];
        
        if (![entireArray containsObject:dicty]) {
            
            [entireArray addObject:dicty];
        }
        
    }
    */
    
    NSMutableArray *entireArray = [NSMutableArray new];
    
    NSMutableArray *allGames = [self getAllFixturesForLeague:lid];
    
    for (NSDictionary *dict in allGames) {
        
        NSString *date = [dict objectForKey:@"date"];
        
        date = [date stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *datey = [dateFormatter dateFromString:date];
        dateFormatter.dateFormat=@"EEEE";
        NSString * dayString = [[dateFormatter stringFromDate:datey] capitalizedString];
        dateFormatter.dateFormat=@"dd";
        NSString * daypos = [[dateFormatter stringFromDate:datey] capitalizedString];
        dateFormatter.dateFormat=@"MMM";
        NSString * monthString = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        dateFormatter.dateFormat=@"yyyy";
        NSString * yearString = [[dateFormatter stringFromDate:datey] capitalizedString];
        
        
        NSString *dString = [NSString stringWithFormat:@"%@ %@ %@ %@",dayString, [self addSuffixToNumber:[daypos intValue]], monthString, yearString];
        NSDictionary *dicty = [[NSDictionary alloc]initWithObjectsAndKeys:date, @"date", dString, @"dateName", nil];
        
        if (![entireArray containsObject:dicty]) {
            
            [entireArray addObject:dicty];
        }
        
    }
    
    return entireArray;
    
}


-(NSString *) addSuffixToNumber:(int) number
{
    NSString *suffix;
    int ones = number % 10;
    int temp = floor(number/10.0);
    int tens = temp%10;
    
    if (tens ==1) {
        suffix = @"th";
    } else if (ones ==1){
        suffix = @"st";
    } else if (ones ==2){
        suffix = @"nd";
    } else if (ones ==3){
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
    
    NSString *completeAsString = [NSString stringWithFormat:@"%d%@",number,suffix];
    return completeAsString;
}

-(NSMutableArray *)getLast5PreviousGames:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        /*
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT fixture_date\
                                          FROM fixtures f\
                                          LEFT OUTER JOIN sub_league sl\
                                          ON sl.id=f.league_id\
                                          WHERE (fixture_date <= '%@ 00:00:00' OR fixture_date <= '%@')\
                                          AND (sl.league_id = %@ OR f.league_id = %@)\
                                          GROUP BY fixture_date\
                                          ORDER BY fixture_date\
                                          DESC LIMIT 5", today, today, lid, lid];
         */

        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT fixture_date\
                                          FROM fixtures f\
                                          LEFT OUTER JOIN sub_league sl\
                                          ON sl.id=f.league_id\
                                          WHERE (fixture_date <= '%@ 00:00:00' OR fixture_date <= '%@')\
                                          AND (sl.league_id = %@ OR f.league_id = %@)\
                                          GROUP BY fixture_date\
                                          ORDER BY fixture_date DESC", today, today, lid, lid];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:fixtureDate, @"date", nil];
                
                [resultsArray addObject:teamDict];
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
}


-(NSMutableArray *)getNext5Games:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        /*
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT fixture_date\
                                          FROM fixtures f\
                                          LEFT OUTER JOIN sub_league sl\
                                          ON sl.id=f.league_id\
                                          WHERE (fixture_date >= '%@ 00:00:00' OR fixture_date >= '%@')\
                                          AND (sl.league_id = %@ OR f.league_id = %@)\
                                          GROUP BY fixture_date\
                                          ORDER BY fixture_date\
                                          ASC LIMIT 5", today, today, lid, lid];
         */
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT fixture_date\
                                          FROM fixtures f\
                                          LEFT OUTER JOIN sub_league sl\
                                          ON sl.id=f.league_id\
                                          WHERE (fixture_date >= '%@ 00:00:00' OR fixture_date >= '%@')\
                                          AND (sl.league_id = %@ OR f.league_id = %@)\
                                          GROUP BY fixture_date\
                                          ORDER BY fixture_date ASC", today, today, lid, lid];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:fixtureDate, @"date", nil];
                
                [resultsArray addObject:teamDict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}



-(NSMutableArray *)getAllFixturesForLeague:(NSString *)lid {
    
    [self getDB];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        /*
         NSString *querySQL = querySQL  = [NSString stringWithFormat:
         @"SELECT fixture_date\
         FROM fixtures f\
         LEFT OUTER JOIN sub_league sl\
         ON sl.id=f.league_id\
         WHERE (fixture_date >= '%@ 00:00:00' OR fixture_date >= '%@')\
         AND (sl.league_id = %@ OR f.league_id = %@)\
         GROUP BY fixture_date\
         ORDER BY fixture_date\
         ASC LIMIT 5", today, today, lid, lid];
         */
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT fixture_date\
                                          FROM fixtures f\
                                          LEFT OUTER JOIN sub_league sl\
                                          ON sl.id=f.league_id\
                                          WHERE (sl.league_id = %@ OR f.league_id = %@)\
                                          GROUP BY fixture_date\
                                          ORDER BY fixture_date DESC", lid, lid];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *fixtureDate = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];
                
                
                NSDictionary *teamDict = [[NSDictionary alloc]initWithObjectsAndKeys:fixtureDate, @"date", nil];
                
                [resultsArray addObject:teamDict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultsArray != nil) {
        
        return resultsArray;
        
    } else {
        
        return nil;
        
    }
    
}



-(NSString *)giveATeamIDAndGetANameBack:(NSString *)tid {
    
    NSString *theName;
    [self getDB];
    
   
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        
        NSString *querySQL = querySQL  = [NSString stringWithFormat:
                                          @"SELECT name FROM teams WHERE id = %@", tid];
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *tn = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];
                
                
                theName = tn;
                
                
            }
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (theName != nil) {
        
        return theName;
        
    } else {
        
        return nil;
        
    }
    
}

//---------------NEW---------------//
-(NSMutableArray *)getLeaguesForLeaguesVC:(NSString *)countryID {
    
    [self getDB];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
     
        /*
        NSString *perc = @"%";
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT l.*\
                              FROM   league l,\
                              team_positions tp\
                              LEFT OUTER JOIN sub_league sl\
                              ON sl.id = tp.league_id\
                              WHERE tp.league_id=l.id\
                              AND l.country_id = %@\
                              AND l.should_show_on_app = 'Y'\
                              AND l.has_subleague <= 1\
                              AND l.description NOT LIKE '%@LEAGUE DOES NOT HAVE TABLE%@'\
                              GROUP  BY l.id\
                              ORDER  BY l.`sort` ASC", countryID, perc, perc];
        */
         
        
        /*
         AND l.description NOT LIKE '%@LEAGUE DOES NOT HAVE TABLE%@'\
         AND l.description NOT LIKE '%@CUP DOES NOT HAVE TABLE%@'\
         */
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT l.*\
                              FROM   league l,\
                              team_positions tp\
                              LEFT OUTER JOIN sub_league sl\
                              ON sl.id = tp.league_id\
                              WHERE  ( tp.league_id = l.id\
                                      OR tp.league_id = sl.id )\
                              AND l.country_id = %@\
                              AND l.should_show_on_app = 'Y'\
                              AND sl.description = 'PHASE HAS TABLE AND IS LEAF'\
                              GROUP  BY l.id\
                              ORDER  BY l.`sort` ASC", countryID];
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *theirID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                leagueName = [leagueName capitalizedString];
                leagueName = [leagueName stringByReplacingOccurrencesOfString:@"Fa" withString:@"FA"];
                
                NSDictionary *dict = @{@"leagueID": theirID, @"name":leagueName};
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}


-(NSMutableArray *)getGroups:(NSString *)leagueID {
    
    [self getDB];
    
    NSString *slid = [self getSubLeagueThatHasTable:leagueID];
    
    if (slid) {
        
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        static sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)  {
            
            NSString *querySQL = [NSString stringWithFormat:@"SELECT logoID from team_positions WHERE league_id=%@ GROUP BY logoID", slid];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(placesDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    NSString *groupName = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];
                    
                    [resultArray addObject:groupName];
                    
                }
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(placesDB);
        
        if (resultArray != nil) {
            
            return resultArray;
            
        } else {
            
            return nil;
            
        }
        
    } else {
        return nil;
    }
    
}

-(NSString *)getSubLeagueThatHasTable:(NSString *)leagueID {
    
    NSString *slid = nil;
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)  {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id from sub_league WHERE league_id=%@ AND description='PHASE HAS TABLE AND IS LEAF' LIMIT 1", leagueID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                slid = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    return slid;
    
}

-(NSMutableArray *)getLeaguesForFormPlayers:(NSString *)countryID {
    
    [self getDB];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    static sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &placesDB) == SQLITE_OK)
    {
        NSString *querySQL =[NSString stringWithFormat:@"SELECT l.id, l.name\
                             FROM league l, form_players_view fpv\
                             LEFT OUTER JOIN sub_league sl\
                             ON (sl.id=fpv.league_id)\
                             WHERE (l.id=fpv.league_id OR sl.league_id=l.id)\
                             AND l.country_id=%@\
                             and l.should_show_on_app='Y'\
                             AND (fpv.p1_goals > 0 OR fpv.p2_goals > 0)\
                             GROUP BY l.id\
                             ORDER BY l.sort ASC", countryID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(placesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *theirID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *leagueName = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                leagueName = [leagueName capitalizedString];
                leagueName = [leagueName stringByReplacingOccurrencesOfString:@"Fa" withString:@"FA"];
                
                NSDictionary *dict = @{@"leagueID": theirID, @"name":leagueName};
                
                [resultArray addObject:dict];
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(placesDB);
    
    if (resultArray != nil) {
        
        return resultArray;
        
    } else {
        
        return nil;
        
    }
    
}

@end
