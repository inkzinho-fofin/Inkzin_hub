-- LibMissoesBloxFruits.luau
local LibMissoesBloxFruits = {}

-- ====== CONSTANTES DOS MARES ======
LibMissoesBloxFruits.NIVEL_ACESSO_SEGUNDO_MAR = 700
LibMissoesBloxFruits.NIVEL_ACESSO_TERCEIRO_MAR = 1500

-- ====== PRIMEIRO MAR (VELHO MUNDO) ======
LibMissoesBloxFruits.PRIMEIRO_MAR = {
    ["Ilha Inicial (Piratas/Marines)"] = {
        NivelRecomendado = "0-10",
        Missoes = {
            {
                Nome = "Derrotar Bandidos/Recrutas",
                NivelNecessario = 0,
                Objetivo = "Derrotar 5 Bandidos (Ilha Pirata) ou 5 Recrutas de Marinha (Ilha Marinha)",
                Recompensas = { Dinheiro = 350, XP = 300 }
            }
        },
        Chefes = {}
    },
    ["Jungle"] = {
        NivelRecomendado = "10-30",
        Missoes = {
            {
                Nome = "Derrotar Macacos",
                NivelNecessario = 10,
                Objetivo = "Derrotar 6 Macacos",
                Recompensas = { Dinheiro = 800, XP = 2300 }
            },
            {
                Nome = "Derrotar Gorilas",
                NivelNecessario = 15,
                Objetivo = "Derrotar 8 Gorilas",
                Recompensas = { Dinheiro = 1200, XP = 4500 }
            },
            {
                Nome = "Derrotar Rei dos Gorilas",
                NivelNecessario = 20,
                Objetivo = "Derrotar o Rei dos Gorilas",
                Recompensas = { Dinheiro = 2000, XP = 9500, ItemEspecial = "Aura" }
            }
        },
        Chefes = { "Rei dos Gorilas", "Especialista em Sabre" }
    },
    ["Vila Pirata"] = {
        NivelRecomendado = "30-60",
        Missoes = {
            {
                Nome = "Derrotar Piratas",
                NivelNecessario = 30,
                Objetivo = "Derrotar 8 Piratas",
                Recompensas = { Dinheiro = 3000, XP = 13000, ItemEspecial = "Cutlass" }
            },
            {
                Nome = "Derrotar Brutos",
                NivelNecessario = 40,
                Objetivo = "Derrotar 8 Brutos",
                Recompensas = { Dinheiro = 3500, XP = 22000, ItemEspecial = "Maça de Ferro" }
            },
            {
                Nome = "Derrotar Bobby o Palhaço",
                NivelNecessario = 55,
                Objetivo = "Derrotar Bobby o Palhaço",
                Recompensas = { Dinheiro = 8000, XP = 45000, ItemEspecial = "Chop" }
            }
        },
        Chefes = { "Bobby o Palhaço" }
    },
    ["Deserto"] = {
        NivelRecomendado = "60-90",
        Missoes = {
            {
                Nome = "Derrotar Bandidos do Deserto",
                NivelNecessario = 60,
                Objetivo = "Derrotar 10 Bandidos do Deserto",
                Recompensas = { Dinheiro = 4000, XP = 45000, ItemEspecial = "Cutlass" }
            },
            {
                Nome = "Derrotar Oficiais do Deserto",
                NivelNecessario = 75,
                Objetivo = "Derrotar 6 Oficiais do Deserto",
                Recompensas = { Dinheiro = 4500, XP = 65000, ItemEspecial = "Cutlass" }
            }
        },
        Chefes = {}
    },
    ["Ilha do Meio"] = {
        NivelRecomendado = "100+",
        Missoes = {
            {
                Nome = "Derrotar Saw",
                NivelNecessario = 100,
                Objetivo = "Derrotar Saw",
                Recompensas = { Dinheiro = nil, XP = nil, ItemEspecial = "Serra de Tubarão (chance)" }
            }
        },
        Chefes = { "Saw" }
    },
    ["Vila Congelada"] = {
        NivelRecomendado = "90-120",
        Missoes = {
            {
                Nome = "Derrotar Bandidos das Neves",
                NivelNecessario = 90,
                Objetivo = "Derrotar 7 Bandidos das Neves",
                Recompensas = { Dinheiro = 5000, XP = 90000, ItemEspecial = "Katana" }
            },
            {
                Nome = "Derrotar Bonecos de Neve",
                NivelNecessario = 100,
                Objetivo = "Derrotar 10 Bonecos de Neve",
                Recompensas = { Dinheiro = 5500, XP = 150000 }
            },
            {
                Nome = "Derrotar Yeti",
                NivelNecessario = 105,
                Objetivo = "Derrotar Yeti",
                Recompensas = { Dinheiro = 10000, XP = 220000 }
            }
        },
        Chefes = { "Yeti", "Almirante de Gelo" }
    },
    ["Fortaleza Marinha"] = {
        NivelRecomendado = "120-150",
        Missoes = {
            {
                Nome = "Derrotar Oficiais Subchefe",
                NivelNecessario = 120,
                Objetivo = "Derrotar 8 Oficiais Subchefe",
                Recompensas = { Dinheiro = 6000, XP = 225000, ItemEspecial = "Dual Katana" }
            },
            {
                Nome = "Derrotar Vice-Almirante",
                NivelNecessario = 130,
                Objetivo = "Derrotar Vice-Almirante",
                Recompensas = { Dinheiro = 15000, XP = 415000, ItemEspecial = "Triple Katana" }
            }
        },
        Chefes = { "Vice-Almirante", "Greybeard (Chefe de Raid)" }
    },
    ["Skylands"] = {
        NivelRecomendado = "150-190",
        Missoes = {
            {
                Nome = "Derrotar Bandidos do Céu",
                NivelNecessario = 150,
                Objetivo = "Derrotar 7 Bandidos do Céu",
                Recompensas = { Dinheiro = 7000, XP = 315000, ItemEspecial = "Dual Katana" }
            },
            {
                Nome = "Derrotar Mestres das Trevas",
                NivelNecessario = 175,
                Objetivo = "Derrotar 8 Mestres das Trevas",
                Recompensas = { Dinheiro = 7500, XP = 450000, ItemEspecial = "Maça de Ferro" }
            }
        },
        Chefes = {}
    },
    ["Prisão"] = {
        NivelRecomendado = "190-250",
        Missoes = {
            {
                Nome = "Derrotar Presos",
                NivelNecessario = 190,
                Objetivo = "Derrotar 8 Presos",
                Recompensas = { Dinheiro = 7000, XP = 550000 }
            },
            {
                Nome = "Derrotar Presos Perigosos",
                NivelNecessario = 210,
                Objetivo = "Derrotar 8 Presos Perigosos",
                Recompensas = { Dinheiro = 7500, XP = 780000, ItemEspecial = "Cutlass" }
            },
            {
                Nome = "Derrotar Diretor da Prisão",
                NivelNecessario = 220,
                Objetivo = "Derrotar Diretor da Prisão",
                Recompensas = { Dinheiro = 6000, XP = 850000 }
            },
            {
                Nome = "Derrotar Chefe Diretor",
                NivelNecessario = 230,
                Objetivo = "Derrotar Chefe Diretor",
                Recompensas = { Dinheiro = 10000, XP = 1000000 }
            },
            {
                Nome = "Derrotar Swan",
                NivelNecessario = 240,
                Objetivo = "Derrotar Swan",
                Recompensas = { Dinheiro = 15000, XP = 1600000, ItemEspecial = "Spider" }
            }
        },
        Chefes = { "Diretor da Prisão", "Chefe Diretor", "Swan" }
    },
    ["Coliseu"] = {
        NivelRecomendado = "250-300",
        Missoes = {
            {
                Nome = "Derrotar Guerreiros com Toga",
                NivelNecessario = 250,
                Objetivo = "Derrotar 7 Guerreiros com Toga",
                Recompensas = { Dinheiro = 7000, XP = 1100000 }
            },
            {
                Nome = "Derrotar Gladiadores",
                NivelNecessario = 275,
                Objetivo = "Derrotar 8 Gladiadores",
                Recompensas = { Dinheiro = 7500, XP = 1300000 }
            }
        },
        Chefes = {}
    },
    ["Vila Magma"] = {
        NivelRecomendado = "300-375",
        Missoes = {
            {
                Nome = "Derrotar Soldados Militares",
                NivelNecessario = 300,
                Objetivo = "Derrotar 9 Soldados Militares",
                Recompensas = { Dinheiro = 8250, XP = 1700000, ItemEspecial = "Katana, Aura" }
            },
            {
                Nome = "Derrotar Espiões Militares",
                NivelNecessario = 325,
                Objetivo = "Derrotar 8 Espiões Militares",
                Recompensas = { Dinheiro = 8500, XP = 2000000, ItemEspecial = "Aura, Flash Step" }
            },
            {
                Nome = "Derrotar Almirante Magma",
                NivelNecessario = 350,
                Objetivo = "Derrotar Almirante Magma",
                Recompensas = { Dinheiro = 15000, XP = 3000000, ItemEspecial = "Magma" }
            }
        },
        Chefes = { "Almirante Magma" }
    },
    ["Cidade Subaquática"] = {
        NivelRecomendado = "375-450",
        Missoes = {
            {
                Nome = "Derrotar Guerreiros Peixes-Homens",
                NivelNecessario = 375,
                Objetivo = "Derrotar 8 Guerreiros Peixes-Homens",
                Recompensas = { Dinheiro = 8750, XP = 3050000, ItemEspecial = "Katana" }
            },
            {
                Nome = "Derrotar Comandos Peixes-Homens",
                NivelNecessario = 400,
                Objetivo = "Derrotar 8 Comandos Peixes-Homens",
                Recompensas = { Dinheiro = 9000, XP = 3350000, ItemEspecial = "Triple Katana" }
            },
            {
                Nome = "Derrotar Senhor dos Peixes-Homens",
                NivelNecessario = 425,
                Objetivo = "Derrotar Senhor dos Peixes-Homens",
                Recompensas = { Dinheiro = 15000, XP = 4250000, ItemEspecial = "Tridente" }
            }
        },
        Chefes = { "Senhor dos Peixes-Homens" }
    },
    ["Skylands (Upper Yard)"] = {
        NivelRecomendado = "450-625",
        Missoes = {
            {
                Nome = "Derrotar Guardiões dos Deuses",
                NivelNecessario = 450,
                Objetivo = "Derrotar 8 Guardiões dos Deuses",
                Recompensas = { Dinheiro = 8750, XP = 4250000, ItemEspecial = "Dual-Headed Blade" }
            },
            {
                Nome = "Derrotar Shandas",
                NivelNecessario = 475,
                Objetivo = "Derrotar 8 Shandas",
                Recompensas = { Dinheiro = 9000, XP = 5000000 }
            },
            {
                Nome = "Derrotar Wysper",
                NivelNecessario = 500,
                Objetivo = "Derrotar Wysper",
                Recompensas = { Dinheiro = 15000, XP = 5700000, ItemEspecial = "Bazooka" }
            },
            {
                Nome = "Derrotar Esquadrões Reais",
                NivelNecessario = 525,
                Objetivo = "Derrotar 8 Esquadrões Reais",
                Recompensas = { Dinheiro = 9500, XP = 5800000 }
            },
            {
                Nome = "Derrotar Soldados Reais",
                NivelNecessario = 550,
                Objetivo = "Derrotar 8 Soldados Reais",
                Recompensas = { Dinheiro = 9750, XP = 6300000 }
            },
            {
                Nome = "Derrotar Deus do Trovão",
                NivelNecessario = 575,
                Objetivo = "Derrotar Deus do Trovão",
                Recompensas = { Dinheiro = 20000, XP = 8000000, ItemEspecial = "Rumble, Pole (1ª Forma)" }
            }
        },
        Chefes = { "Deus do Trovão", "Wysper" }
    },
    ["Cidade da Fonte"] = {
        NivelRecomendado = "625-700",
        Missoes = {
            {
                Nome = "Derrotar Piratas da Galera",
                NivelNecessario = 625,
                Objetivo = "Derrotar 8 Piratas da Galera",
                Recompensas = { Dinheiro = 10000, XP = 7500000, ItemEspecial = "Katana" }
            },
            {
                Nome = "Derrotar Capitães da Galera",
                NivelN
				
