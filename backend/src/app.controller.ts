import { Controller, Get ,Body,Post} from '@nestjs/common';
import { AppService,PlayerService,TournamentService } from './app.service';
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
@Controller('players')
export class PlayerController {
  constructor(private readonly playerService: PlayerService) {}

  @Post()
  async createPlayers(@Body()  body: any) {
    return this.playerService.createPlayers(body.players);
  }
}
@Controller('tournaments')
export class TournamentController {
  constructor(
    private readonly tournamentService: TournamentService,
  ) {}

  @Post()
  async createTournament() {
    return this.tournamentService.createTournament();
  }
}