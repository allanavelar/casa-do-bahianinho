﻿package br.com.casasbahia.casadobahianinho.cadastro
{	
	public class BrazillianStates {
		
		public static const STATES:Array = [
			{ uf: "AC", name: "Acre" },
			{ uf: "AL", name: "Alagoas" },
			{ uf: "AP", name: "Amapá" },
			{ uf: "AM", name: "Amazonas" },
			{ uf: "BA", name: "Bahia" },
			{ uf: "CE", name: "Ceará" },
			{ uf: "DF", name: "Distrito Federal" },
			{ uf: "ES", name: "Espírito Santo" },
			{ uf: "GO", name: "Goiás" },
			{ uf: "MA", name: "Maranhão" },
			{ uf: "MT", name: "Mato Grosso" },
			{ uf: "MS", name: "Mato Grosso do Sul" },
			{ uf: "MG", name: "Minas Gerais" },
			{ uf: "PA", name: "Pará" },
			{ uf: "PB", name: "Paraíba" },
			{ uf: "PR", name: "Paraná" },
			{ uf: "PE", name: "Pernambuco" },
			{ uf: "PI", name: "Piauí" },
			{ uf: "RJ", name: "Rio de Janeiro" },
			{ uf: "RN", name: "Rio Grande do Norte" },
			{ uf: "RS", name: "Rio Grande do Sul" },
			{ uf: "RO", name: "Rondônia" },
			{ uf: "RR", name: "Roraima" },
			{ uf: "SC", name: "Santa Catarina" },
			{ uf: "SP", name: "São Paulo" },
			{ uf: "SE", name: "Sergipe" },
			{ uf: "TO", name: "Tocantins" }
		];
		
		public static function getAll():Array {
			return STATES;
		}
		
		public function BrazillianStates() { throw new Error("static data only!"); }
		
	}
	
}