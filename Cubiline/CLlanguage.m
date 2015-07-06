#import "CLlanguage.h"

@interface CLLAnguage()
{
	
}

- (void)setDictionaryForEnglish;
- (void)setDictionaryForSpanish;

@end

@implementation CLLAnguage
@synthesize Language;
@synthesize GameStrings;

- (id)init
{
	self  = [super init];
	
	if(self)
	{
		Language = [NSLocale currentLocale].localeIdentifier;
		GameStrings = [[NSMutableDictionary alloc] init];
		
		if([[Language substringToIndex:2] isEqual:@"es"])
		{
			[self setDictionaryForSpanish];
		}
		else
		{
			[self setDictionaryForEnglish];
		}
	}
	
	return self;
}

+ (instancetype)sharedCLLanguage
{
	static CLLAnguage* sharedCLLanguage;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{sharedCLLanguage = [[CLLAnguage alloc] init];});
	
	return sharedCLLanguage;
}

- (NSString*)stringForKey:(NSString*)key
{
	return [GameStrings objectForKey:key];
}

- (void)setDictionaryForEnglish
{
	[GameStrings setObject:@"Play" forKey:@"main_menu_play"];
	[GameStrings setObject:@"Setup" forKey:@"main_menu_play_lobby"];
	[GameStrings setObject:@"Game Center" forKey:@"main_menu_gc"];
	[GameStrings setObject:@"About" forKey:@"main_menu_about"];
	[GameStrings setObject:@"How To Play" forKey:@"main_menu_howto"];
	
	[GameStrings setObject:@"Version" forKey:@"about_version"];
	[GameStrings setObject:@"Developed by" forKey:@"about_developed"];
	
	[GameStrings setObject:@"Tap to continue" forKey:@"help_tap_next"];
	[GameStrings setObject:@"Tap to finish" forKey:@"help_tap_finish"];
	[GameStrings setObject:@"How To Turn" forKey:@"help_howto_turn_title"];
	[GameStrings setObject:@"Drag to the direction you want to turn to." forKey:@"help_howto_turn_text"];
	[GameStrings setObject:@"How To U-Turn" forKey:@"help_howto_return_title"];
	[GameStrings setObject:@"Drag to the opposite direction tilting the sweep." forKey:@"help_howto_return_text"];
	[GameStrings setObject:@"How To Special Blocks" forKey:@"help_howto_eat_title"];
	[GameStrings setObject:@"It gives 1 point and grows the line by 1." forKey:@"help_howto_eat_blue_text"];
	[GameStrings setObject:@"It gives 10 points and grows the line by 10." forKey:@"help_howto_eat_green_text"];
	[GameStrings setObject:@"It gives 10 points but the line doesn't grow." forKey:@"help_howto_eat_orange_text"];
	[GameStrings setObject:@"It gives you 600 coins." forKey:@"help_howto_eat_yellow_text"];
	[GameStrings setObject:@"It reduces the line by 10." forKey:@"help_howto_eat_gray_text"];
	[GameStrings setObject:@"The line becomes a ghost (can't crash)." forKey:@"help_howto_eat_white_text"];
	[GameStrings setObject:@"How To Use Coins" forKey:@"help_howto_power_title"];
	[GameStrings setObject:@"Pause the game and you can" forKey:@"help_howto_power_time_text1"];
	[GameStrings setObject:@"look around and decide what" forKey:@"help_howto_power_time_text2"];
	[GameStrings setObject:@"to do next." forKey:@"help_howto_power_time_text3"];
	[GameStrings setObject:@"For 1000 coins you can have" forKey:@"help_howto_power_reduct_text1"];
	[GameStrings setObject:@"the same effect as the gray" forKey:@"help_howto_power_reduct_text2"];
	[GameStrings setObject:@"block whenever you like." forKey:@"help_howto_power_reduct_text3"];
	[GameStrings setObject:@"For 1000 coins you can have" forKey:@"help_howto_power_ghost_text1"];
	[GameStrings setObject:@"the same effect as the white" forKey:@"help_howto_power_ghost_text2"];
	[GameStrings setObject:@"block whenever you like." forKey:@"help_howto_power_ghost_text3"];
	
	[GameStrings setObject:@"Buy 10,000 " forKey:@"setup_buy"];
	[GameStrings setObject:@"Setup" forKey:@"setup_level"];
	[GameStrings setObject:@"Cube Size" forKey:@"setup_size"];
	[GameStrings setObject:@"Line Speed" forKey:@"setup_speed"];
	
	[GameStrings setObject:@"Continue" forKey:@"game_continue"];
	[GameStrings setObject:@"Try again" forKey:@"game_again"];
	[GameStrings setObject:@"Restart" forKey:@"game_restart"];
	[GameStrings setObject:@"Scores" forKey:@"game_scores"];
	[GameStrings setObject:@"Main Menu" forKey:@"game_menu"];
	[GameStrings setObject:@"New Record" forKey:@"game_record"];
	[GameStrings setObject:@"Win Coins" forKey:@"game_get_coins"];
	
	[GameStrings setObject:@"Coins" forKey:@"level_coins"];
	[GameStrings setObject:@"Ghost" forKey:@"level_ghost"];
}

- (void)setDictionaryForSpanish
{
	[GameStrings setObject:@"Jugar" forKey:@"main_menu_play"];
	[GameStrings setObject:@"Configurar" forKey:@"main_menu_play_lobby"];
	[GameStrings setObject:@"Game Center" forKey:@"main_menu_gc"];
	[GameStrings setObject:@"Creditos" forKey:@"main_menu_about"];
	[GameStrings setObject:@"Como Jugar" forKey:@"main_menu_howto"];
	
	[GameStrings setObject:@"Version" forKey:@"about_version"];
	[GameStrings setObject:@"Desarrollado por" forKey:@"about_developed"];
	
	[GameStrings setObject:@"Toca para continuar" forKey:@"help_tap_next"];
	[GameStrings setObject:@"Toca para terminar" forKey:@"help_tap_finish"];
	[GameStrings setObject:@"Como Girar" forKey:@"help_howto_turn_title"];
	[GameStrings setObject:@"Arrastra hacia el lado que deseas girar." forKey:@"help_howto_turn_text"];
	[GameStrings setObject:@"Como Girar Rapido" forKey:@"help_howto_return_title"];
	[GameStrings setObject:@"Arrastra hacia la direccion contraria inclinando." forKey:@"help_howto_return_text"];
	[GameStrings setObject:@"Bloques Especiales" forKey:@"help_howto_eat_title"];
	[GameStrings setObject:@"Da 1 punto y la linea crece en 1." forKey:@"help_howto_eat_blue_text"];
	[GameStrings setObject:@"Da 10 puntos y la linea crece en 10." forKey:@"help_howto_eat_green_text"];
	[GameStrings setObject:@"Da 10 puntos pero la linea no crece." forKey:@"help_howto_eat_orange_text"];
	[GameStrings setObject:@"Te da 600 moneducas." forKey:@"help_howto_eat_yellow_text"];
	[GameStrings setObject:@"Reduce la linea en 10." forKey:@"help_howto_eat_gray_text"];
	[GameStrings setObject:@"La linea se vuelve fantasma (No chocas)." forKey:@"help_howto_eat_white_text"];
	[GameStrings setObject:@"Como Usar Las Monedas" forKey:@"help_howto_power_title"];
	[GameStrings setObject:@"Pausa el juego y puedes" forKey:@"help_howto_power_time_text1"];
	[GameStrings setObject:@"mirar alrededor y decidir" forKey:@"help_howto_power_time_text2"];
	[GameStrings setObject:@"que hacer." forKey:@"help_howto_power_time_text3"];
	[GameStrings setObject:@"Por 1000 monedas tienes el" forKey:@"help_howto_power_reduct_text1"];
	[GameStrings setObject:@"mismo efecto que el bloque gris" forKey:@"help_howto_power_reduct_text2"];
	[GameStrings setObject:@"en el momento que quieras." forKey:@"help_howto_power_reduct_text3"];
	[GameStrings setObject:@"Por 1000 monedas tienes el" forKey:@"help_howto_power_ghost_text1"];
	[GameStrings setObject:@"mismo efecto que el bloque blanco" forKey:@"help_howto_power_ghost_text2"];
	[GameStrings setObject:@"en el momento que quieras." forKey:@"help_howto_power_ghost_text3"];
	
	[GameStrings setObject:@"Comprar 10,000 " forKey:@"setup_buy"];
	[GameStrings setObject:@"Configurar" forKey:@"setup_level"];
	[GameStrings setObject:@"Tama\x7fo" forKey:@"setup_size"];
	[GameStrings setObject:@"Velocidad" forKey:@"setup_speed"];
	
	[GameStrings setObject:@"Continuar" forKey:@"game_continue"];
	[GameStrings setObject:@"De nuevo" forKey:@"game_again"];
	[GameStrings setObject:@"Reiniciar" forKey:@"game_restart"];
	[GameStrings setObject:@"Puntajes" forKey:@"game_scores"];
	[GameStrings setObject:@"Menu" forKey:@"game_menu"];
	[GameStrings setObject:@"Nuevo Record" forKey:@"game_record"];
	[GameStrings setObject:@"Gana Monedas" forKey:@"game_get_coins"];
	
	[GameStrings setObject:@"Monedas" forKey:@"level_coins"];
	[GameStrings setObject:@"Fantasma" forKey:@"level_ghost"];
}

@end