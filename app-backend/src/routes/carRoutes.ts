import express from 'express';
import { getCars, createCar, brandCar, carBrands, favCar, getFavCars, unFavCar } from '../controllers/carController';

const router = express.Router();

router.get('/', getCars);
router.post('/', createCar);
router.get('/brand/:brand', brandCar);
router.get('/brands', carBrands);
router.post('/fav/:id', favCar);
router.post('/unfav/:id', unFavCar);
router.get('/fav', getFavCars);

export default router;
