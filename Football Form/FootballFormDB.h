//
//  FootballFormDB.h
//  Football Form
//
//  Created by Aaron Wilkinson on 29/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface FootballFormDB : NSObject {
    
    NSManagedObjectContext *localContext;
    sqlite3 *placesDB;
    NSString *databasePath;
    
    NSMutableArray *test;
    
}


@property (strong, nonatomic, getter=getCurrentViewController) UIViewController *currentViewController;
- (UIViewController *)getCurrentViewController; // Unsafe if no current view controller is set!!


+(FootballFormDB *)sharedInstance;

//Here we get future games
-(NSMutableArray *)getFutureFixtureForGame:(NSString *)gameAmount todaysDate:(NSString *)date withFixtureID:(NSString *)fixtureID;

-(NSMutableArray *)getFixturesForDateNew:(NSString *)date andFixture:(NSString *)fixtureID;

//Here we get the previous games
-(NSMutableArray *)getPastFixtureForGame:(NSString *)gameAmount todaysDate:(NSString *)date withFixtureID:(NSString *)fixtureID;

//We give the date and LEAGUE id and get back the games
//-(NSMutableArray *)getFixturesForDate:(NSString *)date andFixture:(NSString *)fixtureID;
-(NSMutableArray *)getFixturesForDate:(NSString *)date andFixture:(NSString *)fixtureID initialFID:(NSString *)initialFID;
//Get back the list of leagues.- (NSMutableArray *)getPlayersPerLeague:(NSString *)leagueID
-(NSMutableArray *)getLeagues;

//Get back the list of leagues and an added 'All' at the top.
-(NSMutableArray *)getLeaguesWithAmmendedAll;

-(NSMutableArray *)getPreviousGamesForTeam:(NSString *)homeTeamID amountOfGames:(NSString *)amount date:(NSString *)date;;

//Here we give the team name and get returned the team id
-(NSString *)getTheTeamIDFromTeamName:(NSString *)teamName;

//Here we get the fixture id based on string values.
-(NSString *)getTheFixtureID:(NSString *)teamHomeID awayTeamID:(NSString *)awayTeamID fixtureDate:(NSString *)fixtureDate;

//Here we give a fixture ID and have the appropriate data returned.
- (NSMutableArray *)getFixtureDataFromFixtureID:(NSString *)fixtureID;

//Here we give a team id and get returned appropriate team data.
- (NSMutableArray *)getTeamDataFromID:(NSString *)teamID;

//Here we get back the league table based on a league id
- (NSMutableArray *)getLeagueTable:(NSString *)leagueID groupText:(NSString *)groupText;

//Here we get back the favourite teams for a user
- (NSMutableArray *)getFavouritesInLeagueTable;

//Here we get back the amount of goals for based on team id
-(int)amountOfGoalsFor:(NSString *)teamID;

//Here we calculate the amount of goals against based on a team id
-(int)goalsAgainst:(NSString *)teamID;

//Here we give a team id and get the amount of points for that team returned
-(int)getPointsForTeam:(NSString *)teamID;

//Here we put in a team ID and get back 'WIN', 'LOOSE' or 'DRAW' depending on their last 5 games. Used for the green / orange / red boxes in leagues.
//- (NSMutableArray *)getLast5GameWinsLoosesDraw:(NSString *)teamID;
- (NSMutableArray *)getLast5GameWinsLoosesDraw:(NSString *)teamID leagueID:(NSString *)leagueID;

//Here we get the league table, based on a league id, filtered by games played
- (NSMutableArray *)getLeagueTableFilterByGamesPlayed:(NSString *)leagueID groupText:(NSString *)groupText;

//Here we get the league table, based on a league id, filtered by games won
- (NSMutableArray *)getLeagueTableFilterByWinner:(NSString *)leagueID groupText:(NSString *)groupText;

//Here we get the league table, based on a league id, filtered by games drawn
- (NSMutableArray *)getLeagueTableFilterByDraw:(NSString *)leagueID groupText:(NSString *)groupText;

//Here we get the league table, based on a league id, filtered by games lost
- (NSMutableArray *)getLeagueTableFilterByGamesLost:(NSString *)leagueID groupText:(NSString *)groupText;

//Here we get the list of all players.
- (NSMutableArray *)getListOfAllPlayers;

//Here we give a specific player id and have returned the club name, as a string.
- (NSString *)getPlayersCurrentTeam:(NSString *)playerID;

//Get all of the players in the current league.
- (NSMutableArray *)getPlayersPerLeague:(NSString *)leagueID;

//Here we have a list of teams returned;
-(NSMutableArray *)listOfTeams;

//Here we loop through all the players and get back the team id and player id
-(NSMutableArray *)playerTeamRelationship;

//Here we give a specific player id and get returned the ID, firstName, surname
-(NSMutableArray *)getPlayerDetails:(NSString *)playerID;

//Here we give the league ID and have returned the team id's of that league
-(NSMutableArray *)getTeamsPerLeague:(NSString *)leagueID;

//Here we give the league ID and have returned the team id's of that league. We also send back the teams name aswell here!
-(NSMutableArray *)getTeamsPerLeagueAndHaveNameReturned:(NSString *)leagueID;

//Here we give the team id and game amount and have returned the scores (home and away)
-(NSMutableArray *)getLastGames:(NSString *)teamID amountOfGames:(NSString *)gameAmount theDate:(NSString *)date;

//Here we give the team id and game amount and have returned the scores (home)
-(NSMutableArray *)getLastGamesHome:(NSString *)teamID amountOfGames:(NSString *)gameAmount theDate:(NSString *)date;

//Here we give the team id and game amount and have returned the scores (away)
-(NSMutableArray *)getLastGamesAway:(NSString *)teamID amountOfGames:(NSString *)gameAmount theDate:(NSString *)date;

//Here is an update statement that updates the is_favourite column under teams.
-(void)updateFavourites:(NSString *)yOrN teamName:(NSString *)teamName;

//Filter league table by total goals for
- (NSMutableArray *)getLeagueTableFilterByGoalsFor:(NSString *)leagueID groupText:(NSString *)groupText;

//Filter league table by total goals against
- (NSMutableArray *)getLeagueTableFilterByGoalsAgainst:(NSString *)leagueID groupText:(NSString *)groupText;

//Filter league table by goal difference
- (NSMutableArray *)getLeagueTableFilterByGoalsDifference:(NSString *)leagueID groupText:(NSString *)groupText;

//Get all players
- (NSMutableArray *)getAllPlayers;

//Get all players in a team
- (NSMutableArray *)getAllPlayersInATeam:(NSString *)teamID  leagueID:(NSString *)leagueID;

//Get all home fixtures for team 
-(NSMutableArray *)getGamesForHomeTeam:(NSString *)teamsHomeId;

//Get the goal scorers per match id
-(NSMutableArray *)getGoalScorersPerMatchID:(NSString *)matchID;

//Get a teams position giving their team id
-(NSString *)getTeamPositionInLeagueTable:(NSString *)teamID;

//Get the name of a player from their id
-(NSString *)getPlayerNameFromID:(NSString *)playerID;

//Give a team id and get back the name of the league it's in
-(NSString *)getLeagueBackFromTeamID:(NSString *)teamID;

//Get yellow cards from a match id
-(NSMutableArray *)getYellowCardsFromMatchID:(NSString *)matchID;

//Get red cards from a match id
-(NSMutableArray *)getRedCardsFromMatchID:(NSString *)matchID;

//Get the total amount of goals per player using a player id
-(NSString *)getPlayersTotalGoals:(NSString *)playerID leagueID:(NSString *)leagueID;

//Get the average time the player scored in using a player id.
-(NSString *)getAverageScoreTimeWithPlayerID:(NSString *)playerID;

//Get total player cards (pass in Red or Yellow) along with a player id.
-(NSString *)getPlayersTotalCards:(NSString *)playerID colour:(NSString *)redOrYellow leagueID:(NSString *)leagueID;

//Get average time a player is given a card, pass in the color (Red or Yellow) and the user id.
-(NSString *)getAverageCardTimeWithPlayerID:(NSString *)playerID;

//Get the amount of goals scored in the last X games for a given player
//-(NSString *)getTotalGoalsPerXGamesWithGameAmount:(NSString *)limit andPlayerID:(NSString *)playerID;
-(NSString *)getTotalGoalsPerXGamesWithGameAmount:(NSString *)limit andPlayerID:(NSString *)playerID leagueID:(NSString *)leagueID;


//Get the last X amount of results whether the team played home or away
//-(NSMutableArray *)statsExplorerGetGamesForBothTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames;

-(NSMutableArray *)statsExplorerGetGamesForBothTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames lid:(NSString *)lid;

//Get the last X amount of results whether the team played away
-(NSMutableArray *)statsExplorerGetGamesForAwayTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames lid:(NSString *)lid;

//Get the last X amount of results whether the team played home
-(NSMutableArray *)statsExplorerGetGamesForHomeTeam:(NSString *)teamsHomeId andAmountOfGames:(NSString *)amountOfGames lid:(NSString *)lid;

//Get the amount of red/yellow cards per player per amount of games
-(NSString *)getTotalCardsPerXGamesWithGameAmount:(NSString *)limit andPlayerID:(NSString *)playerID cardColour:(NSString *)redOrYellow leagueID:(NSString *)leagueID;

//Average time goals have been scored per X games for a player id
-(NSString *)getAverageGoalScoreTimePerGame:(NSString *)limit andPlayerID:(NSString *)playerID;

//Average time a card is recieved per X games for a player id
-(NSString *)getAverageTimeCardRecievedPerGame:(NSString *)limit andPlayerID:(NSString *)playerID;

//Get the total goals per player by passing in the period. 1 = first half 2 = second half;
-(NSMutableArray *)getPlayerTotalGoalsPerPhase:(NSString *)period ascOrDesc:(NSString *)ascOrDesc;

//Get the form players! Enter league id as 1234567 to show all the leagues else enter in a league id. We can also filter this by the amount of games.
//-(NSMutableArray *)getFormPlayers:(NSString *)leagueID limitBy:(NSString *)amountToLimitBy;

//Get line ups by providing a match id
-(NSMutableArray *)getLineUpsPerMatchID:(NSString *)matchID;

//Get fixtures by home and away, manually calculating if they won lost or drew etc.
-(NSMutableArray *)getHomeOrAwayFixtures:(NSString *)lid;

//I give a league ID and get back all the teams who have PLAYED in that league.
-(NSMutableArray *)getTeamIDPerFixtureViaLeague:(NSString *)lid;

//Testing. This should get the league table, only with home statistics
- (NSMutableArray *)getLeagueTableHome:(NSString *)leagueID orderBy:(NSString *)orderBy groupText:(NSString *)groupText;

//This should get the league table, only with away statistics and ordering by;
- (NSMutableArray *)getLeagueTableAway:(NSString *)leagueID orderBy:(NSString *)orderBy groupText:(NSString *)groupText;

//This will get the last 5 and next 5 games
-(NSMutableArray *)getLastAvailableGamesPerLeague:(NSString *)lid;

//Here we give a team id and get the teams name back
-(NSString *)giveATeamIDAndGetANameBack:(NSString *)tid;

//Get the RSS feed links
-(NSMutableArray *)getRSSFeedLinks;

//Because we download a new version of the database each time, we need to get the favourites before doing that, so we get the favourites, download new database then will reinsert.
- (NSMutableArray *)getFavouritesInLeagueTableForTempSaving;

//Get form players, looking only at first half
//-(NSMutableArray *)getFormPlayersHome:(NSString *)leagueID limitBy:(NSString *)amountToLimitBy;

//Get form players, looking only at second half
//-(NSMutableArray *)getFormPlayersAway:(NSString *)leagueID limitBy:(NSString *)amountToLimitBy;

//Here we get players goals filtered by 'Home' or 'Away'
-(NSString *)getPlayersTotalGoalsHomeAway:(NSString *)playerID homeAway:(NSString *)homeAway;

-(NSString *)getTotalGoalsPerXGamesWithGameAmountHome:(NSString *)limit andPlayerID:(NSString *)playerID leagueID:(NSString *)leagueID;
-(NSString *)getTotalGoalsPerXGamesWithGameAmountAway:(NSString *)limit andPlayerID:(NSString *)playerID leagueID:(NSString *)leagueID;

//NEW: Get the countries
-(NSMutableArray *)getCountries:(NSString *)continent;

//NEW: Get leagues based on a country id
-(NSMutableArray *)getLeaguesForCountry:(NSString *)countryID;

//NEW: Here we get the list of continents
-(NSMutableArray *)getContinents;

//NEW: Get the stages after leagues, ie FA Cup->QuarterFinal
-(NSMutableArray *)getSubLeagues;

-(NSMutableArray *)getLeaguesForLeaguesVC:(NSString *)countryID;



-(NSMutableArray *)getLeaguesForCountryFixtures:(NSString *)countryID;
-(NSMutableArray *)getLeaguesForFormPlayers:(NSString *)countryID;

-(NSMutableArray *)getFormPlayers:(NSString *)leagueID side:(NSString *)side;


-(void)updateFavouritesWithLeague:(NSString *)yOrN teamName:(NSString *)teamName lid:(NSString *)lid;

-(NSMutableArray *)getGroups:(NSString *)leagueID;

@end
