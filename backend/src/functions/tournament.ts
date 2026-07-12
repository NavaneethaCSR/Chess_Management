import {Entity ,Column,PrimaryGeneratedColumn}from 'typeorm';
@Entity('tournaments')
export class Tournament {

@PrimaryGeneratedColumn()
  id: number;

  @Column()
  tournamentId: number; 
  
   @Column()
  playerA: string;

  @Column()
  playerB: string;

  @Column()
  winner: string;
  
}