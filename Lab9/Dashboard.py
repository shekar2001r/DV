import dash
from dash.dependencies import Input, Output, State
import dash_core_components as dcc
import dash_html_components as html
import requests

app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1('Pokémon Dashboard'),
    
    html.Div([
        html.Label('Enter Pokémon Name or ID:'),
        dcc.Input(
            id='pokemon-input',
            type='text',
            value=''
        ),
        html.Button('Search', id='submit-val', n_clicks=0)
    ]),
    
    html.Br(),
    
    html.Div(id='pokemon-details'),
    
    html.Br(),
    
    html.Div(id='pokemon-stats')
])

@app.callback(
    [Output('pokemon-details', 'children'),
     Output('pokemon-stats', 'children')],
    [Input('submit-val', 'n_clicks')],
    [State('pokemon-input', 'value')])
def update_pokemon_details(n_clicks, input_value):
    if n_clicks == 0:
        return [html.Div(), html.Div()]
    
    # Make API call to get details of the Pokémon
    pokemon_api_url = f'https://pokeapi.co/api/v2/pokemon/{input_value.lower()}/'
    pokemon_data = requests.get(pokemon_api_url).json()
    
    # Get details of the Pokémon
    name = pokemon_data['name'].title()
    id_num = pokemon_data['id']
    image_url = pokemon_data['sprites']['front_default']
    type_1 = pokemon_data['types'][0]['type']['name'].title()
    try:
        type_2 = pokemon_data['types'][1]['type']['name'].title()
    except:
        type_2 = ''
        
    # Display details of the Pokémon
    pokemon_details = html.Div([
        html.H2(f'{name} - #{id_num}'),
        html.Img(src=image_url, style={'height': '150px'}),
        html.H4('Type(s):'),
        html.Ul([
            html.Li(type_1),
            html.Li(type_2)
        ])
    ])
    
    # Get stats of the Pokémon
    stats = pokemon_data['stats']
    stat_names = [stat['stat']['name'].title() for stat in stats]
    stat_values = [stat['base_stat'] for stat in stats]
    
    # Display stats of the Pokémon
    pokemon_stats = html.Div([
        html.H2('Stats:'),
        html.Table([
            html.Thead([
                html.Tr([html.Th('Stat'), html.Th('Value')])
            ]),
            html.Tbody([
                html.Tr([html.Td(stat_names[i]), html.Td(stat_values[i])]) for i in range(len(stats))
            ])
        ])
    ])
    
    return [pokemon_details, pokemon_stats]

if __name__ == '__main__':
    app.run_server(debug=True)
