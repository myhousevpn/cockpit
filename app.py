from flask import Flask, render_template, request
import subprocess
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/duckdns')
def duckdns():
    return render_template('duckdns.html')

@app.route('/run_script', methods=['POST'])
def run_script():
    new_host_subdomains = request.form['myhousevpn_host_subdomains']
    new_token = request.form['myhousevpn_token']
    
    script_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'domain_token.sh')
    
    print(f"Script path: {script_path}")
    
    if not os.path.exists(script_path):
        return render_template('result.html', success=False, result=f"Script file not found: {script_path}")
    
    if not os.access(script_path, os.X_OK):
        os.chmod(script_path, 0o755)
    
    result = subprocess.run(
        [script_path, new_host_subdomains, new_token, new_host_subdomains],
        capture_output=True, text=True
    )
    
    if result.returncode == 0:
        return render_template('result.html', success=True, result=result.stdout)
    else:
        return render_template('result.html', success=False, result=result.stderr)


@app.route('/downloads')
def downloads():
    return render_template('downloads.html')
@app.route('/vpn')
def vpn():
    return render_template('vpn.html')
@app.route('/support')
def support():
    return render_template('support.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=False)
