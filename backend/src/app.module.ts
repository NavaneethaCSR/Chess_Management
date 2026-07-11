import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Player } from './functions/player';
import { Match } from './functions/match';
import { Tournament } from './functions/tournament';
import { AppController, PlayerController,TournamentController } from './app.controller';
import { AppService, PlayerService,TournamentService } from './app.service';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'sqlite',
      database: 'database.sqlite', // SQLite database file
      entities: [Player,Match],
      synchronize: true,
    }),

    TypeOrmModule.forFeature([Player,Match,Tournament]),
  ],
  controllers: [AppController, PlayerController,TournamentController],
  providers: [AppService, PlayerService,TournamentService],
})
export class AppModule {}