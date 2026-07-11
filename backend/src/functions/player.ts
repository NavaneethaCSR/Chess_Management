import {Entity ,Column,PrimaryGeneratedColumn}from 'typeorm';
@Entity('players')
export class Player {

@PrimaryGeneratedColumn()
  id: number;

   @Column()
  name: string;
  
   @Column()
  team: string;
}