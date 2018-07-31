From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkan.goksu@usishi.com>
Subject: mpt3sas_cm2: attempting host reset! scmd(ffff9e8a88623d48
Date: Tue, 31 Jul 2018 16:57:24 +0300
Message-ID: <CAPu=dv3Px-Y0RRuqasps21=1F4s0Gc9iM5JEQxo-WpVxBKvUOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0000000000002ab99c05724bf533"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--0000000000002ab99c05724bf533
Content-Type: text/plain; charset="UTF-8"

Hello.

When a disk starts to give I/O error mpt3sas going to reset device first
and after the reset if disk still gives "task abort" and "I/O error" then
mpt3sas resets the HBA card. Because of the problem I lost 1 HBA(LSI) card
"this means 100 disk at same time" for 30-50 second.
I was have the problem since 9-10 months so i found a solution with adding
extra timeout to my disks.

--> "for drive in /sys/block/sd*; do echo 180 >  $drive/device/timeout;
done"

After increase disk timeout, for a long time i saw I/O errors but mpt3sas
did not reset HBA card and i was thinking this problem solved But after few
months same problem occured some how.
Now i'm looking for a better solution. Any idea please?

This is the dmesg; https://paste.ubuntu.com/p/ZWcRK3BTRV/

OS: Arch Linux 4.14.40-1-lts #1 SMP Wed May 9 13:00:32 CEST 2018 x86_64
GNU/Linux

[Mon Jul 23 05:16:09 2018] mpt3sas_cm2: attempting host reset!
scmd(ffff9e8a88623d48)
[Mon Jul 23 05:16:09 2018] mpt3sas_cm2: sending diag reset !!
[Mon Jul 23 05:16:10 2018] mpt3sas_cm2: diag reset: SUCCESS
[Mon Jul 23 05:16:10 2018] mpt3sas_cm2: LSISAS3008: FWVersion(13.00.00.00),
ChipRevision(0x02), BiosVersion(08.35.00.00)
[Mon Jul 23 05:16:10 2018] mpt3sas_cm2: Protocol=(
[Mon Jul 23 05:16:10 2018] mpt3sas_cm2: sending port enable !!
[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: port enable: SUCCESS
[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: search for end-devices: start
[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: search for end-devices: complete
[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: search for expanders: start
[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: search for expanders: complete
[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: host reset: SUCCESS
scmd(ffff9e8a88623d48)
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: removing unresponding devices: start
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: removing unresponding devices:
end-devices
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: removing unresponding devices:
expanders
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: removing unresponding devices:
complete
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: scan devices: start
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: scan devices: expanders start
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: break from expander scan:
ioc_status(0x0022), loginfo(0x310f0400)
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: scan devices: expanders complete
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: scan devices: end devices start
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: break from end device scan:
ioc_status(0x0022), loginfo(0x310f0400)
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: scan devices: end devices complete
[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: scan devices: complete

--0000000000002ab99c05724bf533
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div class=3D"gmail_signature"><div dir=3D"ltr"><div =
dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"=
ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail=
-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-col=
ourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><=
font color=3D"#000000" face=3D"Consolas, Lucida Console, monospace"><span s=
tyle=3D"font-size:12.8px">Hello.</span></font></div><div class=3D"gmail-m_4=
219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourl=
ine" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><font=
 color=3D"#000000" face=3D"Consolas, Lucida Console, monospace"><span style=
=3D"font-size:12.8px"><br></span></font></div><div class=3D"gmail-m_4219257=
025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" s=
tyle=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><font color=
=3D"#000000" face=3D"Consolas, Lucida Console, monospace"><span style=3D"fo=
nt-size:12.8px">When a disk starts to give I/O error mpt3sas going to reset=
 device first and after the reset if disk still gives &quot;task abort&quot=
; and &quot;I/O error&quot; then mpt3sas resets the HBA card. Because of th=
e problem I lost 1 HBA(LSI) card &quot;this means 100 disk at same time&quo=
t; for 30-50 second.</span></font></div><div class=3D"gmail-m_4219257025177=
119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=
=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><span style=3D"=
color:rgb(0,0,0);font-family:Consolas,&quot;Lucida Console&quot;,monospace;=
font-size:12.8px">I was have the problem since 9-10 months so i found a sol=
ution with adding extra timeout to my disks.</span><br></div><div class=3D"=
gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmai=
l-colourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-wo=
rd"><font color=3D"#000000" face=3D"Consolas, Lucida Console, monospace"><s=
pan style=3D"font-size:12.8px"><br></span></font></div><div class=3D"gmail-=
m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colo=
urline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><f=
ont color=3D"#000000" face=3D"Consolas, Lucida Console, monospace"><span st=
yle=3D"font-size:12.8px">--&gt; &quot;for drive in /sys/block/sd*; do echo =
180 &gt;=C2=A0 $drive/device/timeout; done&quot;</span></font></div><div cl=
ass=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119=
855gmail-colourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:b=
reak-word"><font color=3D"#000000" face=3D"Consolas, Lucida Console, monosp=
ace"><span style=3D"font-size:12.8px"><br></span></font></div><div class=3D=
"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gma=
il-colourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-w=
ord"><font color=3D"#000000" face=3D"Consolas, Lucida Console, monospace"><=
span style=3D"font-size:12.8px">After increase disk timeout, for a long tim=
e i saw I/O errors but mpt3sas did not reset HBA card and i was thinking th=
is problem solved=C2=A0</span></font><span style=3D"font-size:12.8px;color:=
rgb(0,0,0);font-family:Consolas,&quot;Lucida Console&quot;,monospace">But a=
fter few months same problem occured some how.</span></div><div class=3D"gm=
ail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-=
colourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word=
"><span style=3D"color:rgb(0,0,0);font-family:Consolas,&quot;Lucida Console=
&quot;,monospace;font-size:12.8px">Now i&#39;m looking for a better solutio=
n.=C2=A0</span><span style=3D"color:rgb(0,0,0);font-family:Consolas,&quot;L=
ucida Console&quot;,monospace;font-size:12.8px">Any idea please?</span></di=
v><div class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257=
025177119855gmail-colourline" style=3D"font-size:12.8px;padding-left:7px;wo=
rd-wrap:break-word"><span style=3D"font-size:12.8px;color:rgb(0,0,0);font-f=
amily:Consolas,&quot;Lucida Console&quot;,monospace"><br></span></div><div =
class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_42192570251771=
19855gmail-colourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap=
:break-word"><span style=3D"color:rgb(0,0,0);font-family:Consolas,&quot;Luc=
ida Console&quot;,monospace;font-size:12.8px">This is the dmesg;=C2=A0</spa=
n><a href=3D"https://paste.ubuntu.com/p/ZWcRK3BTRV/" target=3D"_blank" styl=
e=3D"font-family:Consolas,&quot;Lucida Console&quot;,monospace;font-size:12=
.8px">https://paste.ubuntu.com/p/<wbr>ZWcRK3BTRV/</a><span style=3D"font-si=
ze:12.8px;color:rgb(0,0,0);font-family:Consolas,&quot;Lucida Console&quot;,=
monospace"><br></span></div><div class=3D"gmail-m_4219257025177119855gmail-=
linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"font-size:=
12.8px;padding-left:7px;word-wrap:break-word"><br></div><div class=3D"gmail=
-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-col=
ourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><=
span style=3D"color:rgb(0,0,0);font-family:Consolas,&quot;Lucida Console&qu=
ot;,monospace;font-size:12.8px">OS: Arch Linux 4.14.40-1-lts #1 SMP Wed May=
 9 13:00:32 CEST 2018 x86_64 GNU/Linux</span><br></div><div class=3D"gmail-=
m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colo=
urline" style=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><s=
pan style=3D"color:rgb(0,0,0);font-family:Consolas,&quot;Lucida Console&quo=
t;,monospace;font-size:12.8px"><br></span></div><div class=3D"gmail-m_42192=
57025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline"=
 style=3D"padding-left:7px;word-wrap:break-word"><div class=3D"gmail-m_4219=
257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline=
" style=3D"padding-left:7px;word-wrap:break-word"><span style=3D"font-size:=
12.8px">[Mon Jul 23 05:16:09 2018] mpt3sas_cm2: attempting host reset! scmd=
(ffff9e8a88623d48)</span></div><div class=3D"gmail-m_4219257025177119855gma=
il-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding=
-left:7px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 2=
3 05:16:09 2018] mpt3sas_cm2: sending diag reset !!</span></div><div class=
=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855=
gmail-colourline" style=3D"padding-left:7px;word-wrap:break-word"><span sty=
le=3D"font-size:12.8px">[Mon Jul 23 05:16:10 2018] mpt3sas_cm2: diag reset:=
 SUCCESS</span></div><div class=3D"gmail-m_4219257025177119855gmail-linesty=
le1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-left:7px;=
word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23 05:16:10=
 2018] mpt3sas_cm2: LSISAS3008: FWVersion(13.00.00.00), ChipRevision(0x02),=
 BiosVersion(08.35.00.00)</span></div><div class=3D"gmail-m_421925702517711=
9855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"=
padding-left:7px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mo=
n Jul 23 05:16:10 2018] mpt3sas_cm2: Protocol=3D(</span></div><div class=3D=
"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gma=
il-colourline" style=3D"padding-left:7px;word-wrap:break-word"><span style=
=3D"font-size:12.8px">[Mon Jul 23 05:16:10 2018] mpt3sas_cm2: sending port =
enable !!</span></div><div class=3D"gmail-m_4219257025177119855gmail-linest=
yle1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-left:7px=
;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23 05:16:1=
7 2018] mpt3sas_cm2: port enable: SUCCESS</span></div><div class=3D"gmail-m=
_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colou=
rline" style=3D"padding-left:7px;word-wrap:break-word"><span style=3D"font-=
size:12.8px">[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: search for end-devices=
: start</span></div><div class=3D"gmail-m_4219257025177119855gmail-linestyl=
e1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-left:7px;w=
ord-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23 05:16:17 =
2018] mpt3sas_cm2: search for end-devices: complete</span></div><div class=
=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855=
gmail-colourline" style=3D"padding-left:7px;word-wrap:break-word"><span sty=
le=3D"font-size:12.8px">[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: search for =
expanders: start</span></div><div class=3D"gmail-m_4219257025177119855gmail=
-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-l=
eft:7px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23 =
05:16:17 2018] mpt3sas_cm2: search for expanders: complete</span></div><div=
 class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177=
119855gmail-colourline" style=3D"padding-left:7px;word-wrap:break-word"><sp=
an style=3D"font-size:12.8px">[Mon Jul 23 05:16:17 2018] mpt3sas_cm2: host =
reset: SUCCESS scmd(ffff9e8a88623d48)</span></div><div class=3D"gmail-m_421=
9257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourlin=
e" style=3D"padding-left:7px;word-wrap:break-word"><span style=3D"font-size=
:12.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: removing unresponding devi=
ces: start</span></div><div class=3D"gmail-m_4219257025177119855gmail-lines=
tyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-left:7p=
x;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23 05:16:=
38 2018] mpt3sas_cm2: removing unresponding devices: end-devices</span></di=
v><div class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257=
025177119855gmail-colourline" style=3D"padding-left:7px;word-wrap:break-wor=
d"><span style=3D"font-size:12.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2:=
 removing unresponding devices: expanders</span></div><div class=3D"gmail-m=
_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colou=
rline" style=3D"padding-left:7px;word-wrap:break-word"><span style=3D"font-=
size:12.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: removing unresponding =
devices: complete</span></div><div class=3D"gmail-m_4219257025177119855gmai=
l-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-=
left:7px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23=
 05:16:38 2018] mpt3sas_cm2: scan devices: start</span></div><div class=3D"=
gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmai=
l-colourline" style=3D"padding-left:7px;word-wrap:break-word"><span style=
=3D"font-size:12.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: <span style=
=3D"white-space:pre">	</span>scan devices: expanders start</span></div><div=
 class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177=
119855gmail-colourline" style=3D"padding-left:7px;word-wrap:break-word"><sp=
an style=3D"font-size:12.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: <span=
 style=3D"white-space:pre">	</span>break from expander scan: ioc_status(0x0=
022), loginfo(0x310f0400)</span></div><div class=3D"gmail-m_421925702517711=
9855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"=
padding-left:7px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mo=
n Jul 23 05:16:38 2018] mpt3sas_cm2: <span style=3D"white-space:pre">	</spa=
n>scan devices: expanders complete</span></div><div class=3D"gmail-m_421925=
7025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" =
style=3D"padding-left:7px;word-wrap:break-word"><span style=3D"font-size:12=
.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: <span style=3D"white-space:pr=
e">	</span>scan devices: end devices start</span></div><div class=3D"gmail-=
m_4219257025177119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colo=
urline" style=3D"padding-left:7px;word-wrap:break-word"><span style=3D"font=
-size:12.8px">[Mon Jul 23 05:16:38 2018] mpt3sas_cm2: <span style=3D"white-=
space:pre">	</span>break from end device scan: ioc_status(0x0022), loginfo(=
0x310f0400)</span></div><div class=3D"gmail-m_4219257025177119855gmail-line=
style1 gmail-m_4219257025177119855gmail-colourline" style=3D"padding-left:7=
px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon Jul 23 05:16=
:38 2018] mpt3sas_cm2: <span style=3D"white-space:pre">	</span>scan devices=
: end devices complete</span></div><div class=3D"gmail-m_421925702517711985=
5gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"pad=
ding-left:7px;word-wrap:break-word"><span style=3D"font-size:12.8px">[Mon J=
ul 23 05:16:38 2018] mpt3sas_cm2: scan devices: complete</span></div><div s=
tyle=3D"font-size:12.8px"><br></div></div><div class=3D"gmail-m_42192570251=
77119855gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=
=3D"font-size:12.8px;padding-left:7px;word-wrap:break-word"><br></div><div =
class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_42192570251771=
19855gmail-colourline" style=3D"font-size:12.8px;padding-left:7px;word-wrap=
:break-word"><font color=3D"#000000" face=3D"Consolas, Lucida Console, mono=
space"><div class=3D"gmail-m_4219257025177119855gmail-linestyle1 gmail-m_42=
19257025177119855gmail-colourline" style=3D"font-size:12.8px;padding-left:7=
px;word-wrap:break-word"><br></div><div class=3D"gmail-m_421925702517711985=
5gmail-linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"fon=
t-size:12.8px;padding-left:7px;word-wrap:break-word"><span style=3D"font-si=
ze:12.8px"><br></span></div><div class=3D"gmail-m_4219257025177119855gmail-=
linestyle1 gmail-m_4219257025177119855gmail-colourline" style=3D"font-size:=
12.8px;padding-left:7px;word-wrap:break-word"><br></div></font></div></div>=
</div></div></div></div></div></div></div></div></div></div>
</div>

--0000000000002ab99c05724bf533--
