from subprocess import Popen, PIPE

cmd: list[str] = ["git", "log", '--pretty=format:"%h %s"']
process = Popen(cmd, stdout=PIPE)
(out, err) = process.communicate()
exit_code = process.wait()

if exit_code != 0:
    print('An error occurred while executing the following command: {}'.format(' '.join(cmd)))

text: list[str] = list(map(lambda x: x.strip("\""), out.decode().split("\n")))
hash_max: int = len(text) - 1

for i in range(0, len(text)-1):
    if i == 0:
        print("{:16} {}".format('HEAD', text[i]))
    else:
        print("{:16} {}".format('HEAD~{}'.format(i), text[i]))

