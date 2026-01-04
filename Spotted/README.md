# Spotted — Aplicativo de Registro de Observação de Aeronaves  

## 1. Introdução

**Spotted** é um aplicativo móvel para iOS desenvolvido para permitir que entusiastas da aviação registrem, cataloguem e revisitem observações de aeronaves de forma estruturada e intuitiva.

O aplicativo é voltado principalmente para praticantes do hobby conhecido como **Plane Spotting** (ou observação de aeronaves). Esse hobby consiste em observar, identificar e registrar aeronaves em aeroportos, áreas próximas a rotas aéreas ou outros pontos estratégicos, geralmente anotando informações como o registro da aeronave, modelo, companhia aérea, local e horário da observação. Para muitos entusiastas, essas observações funcionam como um registro pessoal e histórico de suas experiências, similar a um diário ou catálogo especializado.

Tradicionalmente, praticantes desse hobby utilizam cadernos, planilhas ou aplicativos genéricos de anotações para armazenar essas informações. O **Spotted** surge como uma solução dedicada, oferecendo uma interface específica para esse tipo de registro, integração com dados externos do setor da aviação e recursos de geolocalização que enriquecem cada observação.

O aplicativo foca na simplicidade de uso, persistência local de dados e manipulação eficiente de informações, ao mesmo tempo em que demonstra a aplicação de tecnologias modernas do ecossistema iOS.

O aplicativo foi projetado como um sistema **local-first**, o que significa que todos os dados do usuário são armazenados localmente no dispositivo, sem a necessidade de autenticação ou sincronização em nuvem. Essa abordagem garante disponibilidade offline, maior privacidade e confiabilidade, características especialmente importantes para usuários que realizam observações em locais com conectividade limitada.

---

## 2. Objetivo e Escopo

O objetivo do *Spotted* é fornecer aos usuários um registro pessoal, organizado e persistente de observações de aeronaves, atendendo às necessidades específicas de praticantes do hobby de Plane Spotting.

O aplicativo permite:

- Registrar observações de aeronaves no momento em que ocorrem  
- Armazenar informações relevantes como registro da aeronave, data, hora e localização  
- Enriquecer automaticamente os registros com dados externos quando disponíveis  
- Visualizar, editar e gerenciar observações registradas  
- Exibir os registros em diferentes formatos de visualização  
- Acessar o contexto geográfico de cada observação por meio de mapas  

Para entusiastas da aviação, o aplicativo funciona como um **catálogo pessoal digital**, permitindo acompanhar quais aeronaves já foram observadas, quando e em que local, além de facilitar a organização e consulta desses dados ao longo do tempo.

Do ponto de vista acadêmico, o projeto demonstra a integração entre design de interface, persistência de dados, consumo de APIs externas, serviços de geolocalização e internacionalização em um único aplicativo móvel, aplicando conceitos práticos de desenvolvimento de software para dispositivos iOS.

---

## 3. Fluxo do Aplicativo e Telas

### 3.1 Tela Inicial (Welcome Screen)

A primeira tela apresentada ao usuário é uma **tela de boas-vindas**, projetada para introduzir o aplicativo e seu propósito.

Essa tela exibe:
- O nome do aplicativo: **Spotted**
- Uma breve descrição: *“Anote e se lembre de todas as aeronaves já vistas”*
- Um único botão de interação: **Comece a registrar**

Ao tocar no botão **Comece a registrar**, o usuário é direcionado para a tela principal do aplicativo.  
A tela de boas-vindas é exibida **todas as vezes que o aplicativo é aberto**, funcionando como uma tela de apresentação. No entanto, após o usuário prosseguir para a tela principal, não é possível retornar a essa tela durante a mesma sessão.

Essa decisão de design simplifica a navegação e reforça o fato de que o aplicativo não depende de autenticação ou contas de usuário.

---

## 3.2 Tela Principal — Catálogo de Aeronaves

A tela principal do aplicativo funciona como um **catálogo de todas as observações de aeronaves** registradas pelo usuário.

#### Visualização Padrão
- O catálogo é exibido inicialmente em formato de **lista**.
- Cada item apresenta:
  - Registro da aeronave
  - Tipo da aeronave (quando disponível)
  - Data e hora em que o registro foi criado

#### Visualização Alternativa
- O usuário pode alternar entre:
  - **Visualização em lista**
  - **Visualização em grade (cards)**

Essa flexibilidade permite que o usuário escolha a forma de visualização que preferir, sem impactar os dados armazenados.

#### Navegação
- Cada item do catálogo é interativo.
- Ao selecionar um item, o usuário é direcionado para a **tela de detalhes** daquela observação específica.

---

## 3.3 Tela de Detalhes — Observação de Aeronave

A tela de detalhes apresenta **todas as informações associadas a uma única observação**.

As informações exibidas incluem:
- Registro da aeronave (prefixo)
- Tipo da aeronave (quando disponível)
- Data e hora da observação
- Coordenadas geográficas onde o registro foi criado
- Imagem da aeronave (quando disponível)
- Um mini mapa indicando o local exato da observação

#### Interação com o Mapa
O mini mapa contém um marcador com um texto gerado dinamicamente no seguinte formato:

> *“Aircraft (registro) spotted here at 00:00 Jan 1 2026”*

Ao tocar no mini mapa, o aplicativo abre o **Apple Maps**, exibindo o marcador na localização exata registrada.

---

## 3.4 Edição de uma Observação

A tela de detalhes inclui um **modo de edição**, permitindo que o usuário altere manualmente alguns campos:

- Tipo da aeronave
- URL da imagem proveniente do JetPhotos

Essa funcionalidade existe principalmente como um mecanismo de contingência, garantindo que o usuário possa completar ou corrigir informações caso a obtenção automática de dados falhe.

#### Download e Cache de Imagens
- A imagem da aeronave é baixada **apenas na primeira vez** em que a tela de detalhes é aberta.
- Após o download, a imagem é **armazenada em cache na memória** durante a sessão do aplicativo.
- Isso evita downloads repetidos, reduz o consumo de banda e elimina oscilações visuais (flickering) na interface.
- Caso o aplicativo seja encerrado e aberto novamente, a imagem poderá ser baixada novamente, se necessário.

Essa abordagem equilibra desempenho, experiência do usuário e eficiência no uso de recursos.

---

## 3.5 Exclusão de uma Observação

No modo de edição, existe um botão **Apagar Registro**.

- O botão é destacado visualmente em vermelho para indicar uma ação destrutiva.
- Ao ser acionado, um modal de confirmação é exibido.
- A observação só é removida do banco de dados local após a confirmação explícita do usuário.

Esse comportamento evita exclusões acidentais e segue boas práticas de usabilidade.

---

## 3.6 Adição de uma Nova Observação

Na tela principal do catálogo, o usuário pode adicionar uma nova observação utilizando o botão **Plus (+)**.

#### Fluxo de Adição
1. O usuário toca no botão de adicionar  
2. Um formulário é exibido solicitando o registro da aeronave  
3. O usuário pressiona o botão **Salvar**

Após o salvamento, o aplicativo automaticamente:
- Cria uma nova entrada no banco de dados local
- Armazena a data e hora atuais
- Obtém a localização do usuário utilizando o **Core Location**

---

## 4. Integração com Dados Externos

### 4.1 Fonte Primária — JetAPI / JetPhotos

Após a criação de uma nova observação, o aplicativo tenta enriquecer os dados consultando a API pública **JetAPI (jetapi.dev)**.

Quando disponível, a API retorna:
- O tipo da aeronave
- A imagem mais recente disponível da aeronave no site JetPhotos

Quando a resposta é bem-sucedida, essas informações são inseridas automaticamente no registro **sem necessidade de intervenção do usuário**.

---

### 4.2 Estratégia de Contingência — Inserção Manual

Caso a API:
- Esteja indisponível  
- Não responda corretamente  
- Não possa ser acessada por restrições de rede  

O aplicativo mantém os campos de tipo da aeronave e imagem vazios.  
Nessa situação, o usuário pode preencher essas informações manualmente por meio do modo de edição.

Essa estratégia híbrida garante que:
- O aplicativo continue totalmente funcional offline  
- Serviços externos melhorem a experiência, mas não sejam obrigatórios  

---

## 5. Tecnologias Utilizadas

O aplicativo foi desenvolvido utilizando as seguintes tecnologias:

- **Swift** — Linguagem de programação principal  
- **SwiftUI** — Framework declarativo para construção da interface  
- **SwiftData** — Persistência local de dados  
- **Core Location** — Captura automática de localização  
- **MapKit** — Visualização geográfica e navegação  
- **String Catalog (i18n)** — Internacionalização e localização  

---

## 6. Internacionalização e Localização

O aplicativo oferece suporte a múltiplos idiomas por meio do uso de **String Catalogs**.

- Todo o texto exibido ao usuário é localizado  
- O idioma do sistema determina qual tradução será utilizada  
- Essa funcionalidade permite que o aplicativo seja facilmente expandido para outros idiomas  

O suporte à internacionalização também demonstra a aplicação de boas práticas no desenvolvimento de aplicativos preparados para uso global.

---
