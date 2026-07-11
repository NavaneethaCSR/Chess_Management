import {Entity ,Column,PrimaryGeneratedColumn}from 'typeorm';
@Entity('match')
export class Match {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  playerA: string;

  @Column()
  playerB: string;

  @Column()
  winner: string;
}