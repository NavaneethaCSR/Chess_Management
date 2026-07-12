import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Player } from './functions/player';
import { Match } from './functions/match';
import { Tournament } from './functions/tournament';
@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }
}
@Injectable()
export class PlayerService {
  constructor(
    @InjectRepository(Player)
    private readonly playerRepository: Repository<Player>,
  ) {}

 async createPlayers(players: any[]) {
  // Remove old players
  await this.playerRepository.clear();

  // Create new players
  const data = this.playerRepository.create(players);

  // Save new players
  return await this.playerRepository.save(data);
}
}

@Injectable()
export class TournamentService {
  constructor(
    @InjectRepository(Player)
    private readonly playerRepository: Repository<Player>,
     @InjectRepository(Match)
    private readonly matchRepository: Repository<Match>,
     @InjectRepository(Tournament)
    private readonly tournamentRepository: Repository<Tournament>,
  ) {}

  async createTournament() {
    await this.matchRepository.clear();
    // Fetch players from each team
    const teamA = await this.playerRepository.find({
      where: { team: 'A' },
    });

    const teamB = await this.playerRepository.find({
      where: { team: 'B' },
    });

    // Shuffle the teams
    teamA.sort(() => Math.random() - 0.5);
    teamB.sort(() => Math.random() - 0.5);

     
const lastTournament = await this.tournamentRepository.find({
  order: {
    tournamentId: 'DESC',
  },
  take: 1,
});

const tournamentId =
  lastTournament.length > 0
    ? lastTournament[0].tournamentId + 1
    : 1;

 const matches: {
    playerA: string;
    playerB: string;
    winner: string;
  }[] = [];

    const count = Math.min(teamA.length, teamB.length);

    for (let i = 0; i < count; i++) {
      const playerA = teamA[i];
      const playerB = teamB[i];

      const winner =
          Math.random() < 0.5 ? playerA : playerB;

     const match = this.matchRepository.create({
  playerA: playerA.name,
  playerB: playerB.name,
  winner: winner.name,
});


 await this.matchRepository.save(match);

    await this.tournamentRepository.save({
      tournamentId,
      playerA: playerA.name,
      playerB: playerB.name,
      winner: winner.name,
    });

    matches.push({
      playerA: playerA.name,
      playerB: playerB.name,
      winner: winner.name,
    });}
  return {
    matches,
  };
  }
}