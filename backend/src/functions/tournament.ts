import {Entity ,Column,PrimaryGeneratedColumn}from 'typeorm';
@Entity('tournaments')
export class Tournament {

@PrimaryGeneratedColumn()
  id: number;

   @Column()
  tournamnet_name: String;
  
  
  @Column()
  rounds: number;
  
}