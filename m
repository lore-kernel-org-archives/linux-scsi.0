From: Lionel Elie Mamane <lionel@mamane.lu>
Subject: PROBLEM: Linux 2.4.19 + aic7xxx driver = crash
Date: Mon, 6 Jan 2003 21:13:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106201330.GA2391@tofu.home.mamane.lu>
References: <20021009133617.GA18381@home.mamane.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from master by tofu.home.mamane.lu with local (Exim 3.35 #1 (Debian))
	id 18Vdco-0000iy-00
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2003 21:13:30 +0100
Content-Disposition: inline
In-Reply-To: <20021009133617.GA18381@home.mamane.lu>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Oct 09, 2002 at 03:36:17PM +0200, Lionel Elie Mamane wrote:
> [1.] One line summary of the problem:

>      Linux 2.4.19 + aic7xxx driver =3D crash

If anyone is interested, I have given it another try, with Linux
2.4.20. Uptime is not yet sufficient to know if problem is still
there, but this time, I have some error messages in my logs after a
few minutes of uptime:

> [2.] Full description of the problem/report:

Jan  6 20:55:01 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:01 home kernel: scsi0: Dumping Card State while idle, at S=
EQADDR 0x7
Jan  6 20:55:01 home kernel: ACCUM =3D 0xa0, SINDEX =3D 0x5, DINDEX =3D=
 0x8c, ARG_2 =3D 0x0
Jan  6 20:55:01 home kernel: HCNT =3D 0x0 SCBPTR =3D 0x0
Jan  6 20:55:01 home kernel: SCSISEQ =3D 0x12, SBLKCTL =3D 0x0
Jan  6 20:55:01 home kernel:  DFCNTRL =3D 0x0, DFSTATUS =3D 0x29
Jan  6 20:55:01 home kernel: LASTPHASE =3D 0x1, SCSISIGI =3D 0x0, SXFRC=
TL0 =3D 0x80
Jan  6 20:55:58 home kernel: SSTAT0 =3D 0x5, SSTAT1 =3D 0xa
Jan  6 20:55:58 home kernel: STACK =3D=3D 0x3, 0xff, 0x15a, 0x0
Jan  6 20:55:58 home kernel: SCB count =3D 12
Jan  6 20:55:58 home kernel: Kernel NEXTQSCB =3D 11
Jan  6 20:55:58 home kernel: Card NEXTQSCB =3D 11
Jan  6 20:55:58 home kernel: QINFIFO entries:=20
Jan  6 20:55:58 home kernel: Waiting Queue entries:=20
Jan  6 20:55:58 home kernel: Disconnected Queue entries: 2:3 1:6=20
Jan  6 20:55:58 home kernel: QOUTFIFO entries:=20
Jan  6 20:55:58 home kernel: Sequencer Free SCB List: 0=20
Jan  6 20:55:58 home kernel: Sequencer SCB Info: 0(c 0x68, s 0x7, l 0, =
t 0xff) 1(c 0x6c, s 0x7, l 0, t 0x6) 2(c 0x6c, s 0x7, l 0, t 0x3)=20
Jan  6 20:55:58 home kernel: Pending list: 0(c 0x6c, s 0x7, l 0), 2(c 0=
x6c, s 0x7, l 0), 4(c 0x6c, s 0x7, l 0), 7(c 0x6c, s 0x7, l 0), 1(c 0x6=
c, s 0x7, l 0), 9(c 0x6c, s 0x7, l 0), 3(c 0x68, s 0x7, l 0), 6(c 0x68,=
 s 0x7, l 0)
Jan  6 20:55:58 home kernel: Kernel Free SCB list: 5 10 8=20
Jan  6 20:55:58 home kernel: DevQ(0:0:0): 100 waiting
Jan  6 20:55:58 home kernel: DevQ(0:2:0): 0 waiting
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Queuing a recovery SCB
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Device is disconnected, re-qu=
euing SCB
Jan  6 20:55:58 home kernel: Recovery code sleeping
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Abort Tag Message Sent
Jan  6 20:55:58 home kernel: QINFIFO entries:=20
Jan  6 20:55:58 home kernel: Waiting Queue entries:=20
Jan  6 20:55:58 home kernel: Disconnected Queue entries:=20
Jan  6 20:55:58 home ippl: ssh connection attempt from 10.0.0.1
Jan  6 20:55:58 home ippl: ssh connection attempt from 10.0.0.1
Jan  6 20:55:58 home kernel: QOUTFIFO entries:=20
Jan  6 20:55:58 home kernel: Sequencer Free SCB List: 1 2 0=20
Jan  6 20:55:58 home kernel: Sequencer SCB Info: 0(c 0x68, s 0x7, l 0, =
t 0xff) 1(c 0x68, s 0x7, l 0, t 0xff) 2(c 0x0, s 0x7, l 0, t 0xff)=20
Jan  6 20:55:58 home kernel: Pending list: 0(c 0x6c, s 0x7, l 0), 2(c 0=
x6c, s 0x7, l 0), 4(c 0x6c, s 0x7, l 0), 7(c 0x6c, s 0x7, l 0)
Jan  6 20:55:58 home kernel: Kernel Free SCB list: 9 3 6 11 5 10 8=20
Jan  6 20:55:58 home kernel: DevQ(0:0:0): 0 waiting
Jan  6 20:55:58 home kernel: DevQ(0:2:0): 0 waiting
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Queuing a recovery SCB
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Device is disconnected, re-qu=
euing SCB
Jan  6 20:55:58 home kernel: Recovery code sleeping
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Abort Tag Message Sent
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): SCB 7 - Abort Tag Completed=
=2E
Jan  6 20:55:58 home kernel: Recovery SCB completes
Jan  6 20:55:58 home kernel: Recovery code awake
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0: Dumping Card State while idle, at S=
EQADDR 0x7
Jan  6 20:55:58 home kernel: ACCUM =3D 0xab, SINDEX =3D 0x1, DINDEX =3D=
 0x8c, ARG_2 =3D 0x0
Jan  6 20:55:58 home kernel: HCNT =3D 0x0 SCBPTR =3D 0x1
Jan  6 20:55:58 home kernel: SCSISEQ =3D 0x12, SBLKCTL =3D 0x0
Jan  6 20:55:58 home kernel:  DFCNTRL =3D 0x0, DFSTATUS =3D 0x29
Jan  6 20:55:58 home kernel: LASTPHASE =3D 0x1, SCSISIGI =3D 0x0, SXFRC=
TL0 =3D 0x80
Jan  6 20:55:58 home kernel: SSTAT0 =3D 0x5, SSTAT1 =3D 0xa
Jan  6 20:55:58 home kernel: STACK =3D=3D 0x3, 0xff, 0x15a, 0xe5
Jan  6 20:55:58 home kernel: SCB count =3D 12
Jan  6 20:55:58 home kernel: Kernel NEXTQSCB =3D 7
Jan  6 20:55:58 home kernel: Card NEXTQSCB =3D 7
Jan  6 20:55:58 home kernel: QINFIFO entries:=20
Jan  6 20:55:58 home kernel: Waiting Queue entries:=20
Jan  6 20:55:58 home kernel: Disconnected Queue entries:=20
Jan  6 20:55:58 home kernel: QOUTFIFO entries:=20
Jan  6 20:55:58 home kernel: Sequencer Free SCB List: 1 2 0=20
Jan  6 20:55:58 home kernel: Sequencer SCB Info: 0(c 0x68, s 0x7, l 0, =
t 0xff) 1(c 0x68, s 0x7, l 0, t 0xff) 2(c 0x0, s 0x7, l 0, t 0xff)=20
Jan  6 20:55:58 home kernel: Pending list: 0(c 0x6c, s 0x7, l 0), 2(c 0=
x6c, s 0x7, l 0), 4(c 0x6c, s 0x7, l 0)
Jan  6 20:55:58 home kernel: Kernel Free SCB list: 1 9 3 6 11 5 10 8=20
Jan  6 20:55:58 home kernel: DevQ(0:0:0): 0 waiting
Jan  6 20:55:58 home kernel: DevQ(0:2:0): 0 waiting
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Queuing a recovery SCB
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Device is disconnected, re-qu=
euing SCB
Jan  6 20:55:58 home kernel: Recovery code sleeping
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Abort Tag Message Sent
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): SCB 4 - Abort Tag Completed=
=2E
Jan  6 20:55:58 home kernel: Recovery SCB completes
Jan  6 20:55:58 home kernel: Recovery code awake
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0: Dumping Card State while idle, at S=
EQADDR 0x7
Jan  6 20:55:58 home kernel: ACCUM =3D 0xad, SINDEX =3D 0x7, DINDEX =3D=
 0x8c, ARG_2 =3D 0x0
Jan  6 20:55:58 home kernel: HCNT =3D 0x0 SCBPTR =3D 0x1
Jan  6 20:55:58 home kernel: SCSISEQ =3D 0x12, SBLKCTL =3D 0x0
Jan  6 20:55:58 home kernel:  DFCNTRL =3D 0x0, DFSTATUS =3D 0x29
Jan  6 20:55:58 home kernel: LASTPHASE =3D 0x1, SCSISIGI =3D 0x0, SXFRC=
TL0 =3D 0x80
Jan  6 20:55:58 home kernel: SSTAT0 =3D 0x5, SSTAT1 =3D 0xa
Jan  6 20:55:58 home kernel: STACK =3D=3D 0x3, 0xff, 0x15a, 0xe5
Jan  6 20:55:58 home kernel: SCB count =3D 12
Jan  6 20:55:58 home kernel: Kernel NEXTQSCB =3D 4
Jan  6 20:55:58 home kernel: Card NEXTQSCB =3D 4
Jan  6 20:55:58 home kernel: QINFIFO entries:=20
Jan  6 20:55:58 home kernel: Waiting Queue entries:=20
Jan  6 20:55:58 home kernel: Disconnected Queue entries:=20
Jan  6 20:55:58 home kernel: QOUTFIFO entries:=20
Jan  6 20:55:58 home kernel: Sequencer Free SCB List: 1 2 0=20
Jan  6 20:55:58 home kernel: Sequencer SCB Info: 0(c 0x68, s 0x7, l 0, =
t 0xff) 1(c 0x68, s 0x7, l 0, t 0xff) 2(c 0x0, s 0x7, l 0, t 0xff)=20
Jan  6 20:55:58 home kernel: Pending list: 0(c 0x6c, s 0x7, l 0), 2(c 0=
x6c, s 0x7, l 0)
Jan  6 20:55:58 home kernel: Kernel Free SCB list: 7 1 9 3 6 11 5 10 8=20
Jan  6 20:55:58 home kernel: DevQ(0:0:0): 0 waiting
Jan  6 20:55:58 home kernel: DevQ(0:2:0): 0 waiting
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Queuing a recovery SCB
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Device is disconnected, re-qu=
euing SCB
Jan  6 20:55:58 home kernel: Recovery code sleeping
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Abort Tag Message Sent
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): SCB 2 - Abort Tag Completed=
=2E
Jan  6 20:55:58 home kernel: Recovery SCB completes
Jan  6 20:55:58 home kernel: Recovery code awake
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0: Dumping Card State while idle, at S=
EQADDR 0x7
Jan  6 20:55:58 home kernel: ACCUM =3D 0xaf, SINDEX =3D 0x4, DINDEX =3D=
 0x8c, ARG_2 =3D 0x0
Jan  6 20:55:58 home kernel: HCNT =3D 0x0 SCBPTR =3D 0x1
Jan  6 20:55:58 home kernel: SCSISEQ =3D 0x12, SBLKCTL =3D 0x0
Jan  6 20:55:58 home kernel:  DFCNTRL =3D 0x0, DFSTATUS =3D 0x29
Jan  6 20:55:58 home kernel: LASTPHASE =3D 0x1, SCSISIGI =3D 0x0, SXFRC=
TL0 =3D 0x80
Jan  6 20:55:58 home kernel: SSTAT0 =3D 0x5, SSTAT1 =3D 0xa
Jan  6 20:55:58 home kernel: STACK =3D=3D 0x3, 0xff, 0x15a, 0xe5
Jan  6 20:55:58 home kernel: SCB count =3D 12
Jan  6 20:55:58 home kernel: Kernel NEXTQSCB =3D 2
Jan  6 20:55:58 home kernel: Card NEXTQSCB =3D 2
Jan  6 20:55:58 home kernel: QINFIFO entries:=20
Jan  6 20:55:58 home kernel: Waiting Queue entries:=20
Jan  6 20:55:58 home kernel: Disconnected Queue entries:=20
Jan  6 20:55:58 home kernel: QOUTFIFO entries:=20
Jan  6 20:55:58 home kernel: Sequencer Free SCB List: 1 2 0=20
Jan  6 20:55:58 home kernel: Sequencer SCB Info: 0(c 0x68, s 0x7, l 0, =
t 0xff) 1(c 0x68, s 0x7, l 0, t 0xff) 2(c 0x0, s 0x7, l 0, t 0xff)=20
Jan  6 20:55:58 home kernel: Pending list: 0(c 0x6c, s 0x7, l 0)
Jan  6 20:55:58 home kernel: Kernel Free SCB list: 4 7 1 9 3 6 11 5 10 =
8=20
Jan  6 20:55:58 home kernel: DevQ(0:0:0): 0 waiting
Jan  6 20:55:58 home kernel: DevQ(0:2:0): 0 waiting
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Queuing a recovery SCB
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Device is disconnected, re-qu=
euing SCB
Jan  6 20:55:58 home kernel: Recovery code sleeping
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): Abort Tag Message Sent
Jan  6 20:55:58 home kernel: (scsi0:A:0:0): SCB 0 - Abort Tag Completed=
=2E
Jan  6 20:55:58 home kernel: Recovery SCB completes
Jan  6 20:55:58 home kernel: Recovery code awake
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Command not found
Jan  6 20:55:58 home kernel: aic7xxx_abort returns 0x2002
Jan  6 20:55:58 home kernel: scsi0:0:0:0: Attempting to queue an ABORT =
message

The latter three messages are repeated a lot of times.

After a dozen of seconds or so, things started working again. While
these messages were flooding the console, all access to the hard disk
was suspended

> [3.] Keywords (i.e., modules, networking, kernel):

>      scsi, aic7xxx

> [4.] Kernel version (from /proc/version):

Linux version 2.4.20-usagi (master@home) (gcc version 2.95.4 20011002 (=
Debian prerelease)) #1 Mon Jan 6 16:47:33 CET 2003

> [5.] Output of Oops.. message (if applicable) with symbolic informati=
on=20
>      resolved (see Documentation/oops-tracing.txt)

>      None.

> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)

Linux home 2.4.20-usagi #1 Mon Jan 6 16:47:33 CET 2003 i686 unknown
=20
Gnu C                  2.95.4
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
modutils               2.4.15
e2fsprogs              1.27
isdn4k-utils           3.1pre4
Linux C Library        2.3.1
Dynamic linker (ldd)   2.3.1
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               2.0.11
Modules Loaded         ipt_MASQUERADE ipt_LOG iptable_nat ip_conntrack =
iptable_mangle iptable_filter ip_tables nfs nfsd lockd sunrpc b1pci b1d=
ma b1 capi capifs kernelcapi capiutil lp apm ppp_deflate zlib_inflate z=
lib_deflate bsd_comp ppp_async ppp_generic slhc microcode ipv6 parport_=
pc parport nls_iso8859-1 nls_cp850

> [7.2.] Processor information (from /proc/cpuinfo):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 3
model name	: Pentium II (Klamath)
stepping	: 4
cpu MHz		: 267.278
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
mmx
bogomips	: 532.48

> [7.3.] Module information (from /proc/modules):

ipt_MASQUERADE          1344   2 (autoclean)
ipt_LOG                 3264  12 (autoclean)
iptable_nat            14260   1 (autoclean) [ipt_MASQUERADE]
ip_conntrack           16908   1 (autoclean) [ipt_MASQUERADE iptable_na=
t]
iptable_mangle          2272   0 (autoclean) (unused)
iptable_filter          1728   1 (autoclean)
ip_tables              10464   7 [ipt_MASQUERADE ipt_LOG iptable_nat ip=
table_mangle iptable_filter]
nfs                    63484   1 (autoclean)
nfsd                   66368   0 (autoclean)
lockd                  47200   1 (autoclean) [nfs nfsd]
sunrpc                 59412   1 (autoclean) [nfs nfsd lockd]
b1pci                   5960   1
b1dma                  10184   0 [b1pci]
b1                     16416   0 [b1pci b1dma]
capi                   17056   6
capifs                  3520   1 [capi]
kernelcapi             29056   5 [b1pci capi]
capiutil               22272   0 [kernelcapi]
lp                      6464   0 (autoclean)
apm                     9216   1 (autoclean)
ppp_deflate             2944   0 (autoclean)
zlib_inflate           18336   0 (autoclean) [ppp_deflate]
zlib_deflate           17472   0 (autoclean) [ppp_deflate]
bsd_comp                3968   0 (autoclean)
ppp_async               6272   1 (autoclean)
ppp_generic            19340   3 (autoclean) [ppp_deflate bsd_comp ppp_=
async]
slhc                    4576   0 (autoclean) [ppp_generic]
microcode               3292   0 (autoclean)
ipv6                  165568  -1
parport_pc             20936   1
parport                22944   1 [lp parport_pc]
nls_iso8859-1           2880   0 (unused)
nls_cp850               3616   0 (unused)

> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/i=
omem)

0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
02f8-02ff : serial(set)
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
  03c0-03df : matrox
03f8-03ff : serial(set)
0778-077a : parport0
0cf8-0cff : PCI conf1
4f00-4f3f : Intel Corp. 82371AB/EB/MB PIIX4 ACPI
5f00-5f1f : Intel Corp. 82371AB/EB/MB PIIX4 ACPI
c000-cfff : PCI Bus #01
d000-d01f : Intel Corp. 82371AB/EB/MB PIIX4 USB
  d000-d01f : usb-uhci
d400-d43f : AVM Audiovisuelles MKTG & Computer System GmbH B1 ISDN
d800-d81f : AVM Audiovisuelles MKTG & Computer System GmbH B1 ISDN
  d800-d81e : b1pciv4-d800
dc00-dc7f : 3Com Corporation 3c905C-TX/TX-M [Tornado]
  dc00-dc7f : 00:0b.0
e000-e07f : 3Com Corporation 3c905C-TX/TX-M [Tornado] (#2)
  e000-e07f : 00:0d.0
e400-e4ff : Adaptec AIC-7861
f000-f00f : Intel Corp. 82371AB/EB/MB PIIX4 IDE



00000000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cc000-000cc7ff : Extension ROM
000cd000-000cd7ff : Extension ROM
000ce000-000d27ff : Extension ROM
000f0000-000fffff : System ROM
00100000-07ffffff : System RAM
  00100000-00236b84 : Kernel code
  00236b85-002bca83 : Kernel data
e0000000-e7ffffff : Intel Corp. 440LX/EX - 82443LX/EX Host bridge
e8000000-ebffffff : PCI Bus #01
  e8000000-e8003fff : Matrox Graphics, Inc. MGA 2164W [Millennium II] A=
GP
    e8000000-e8003fff : matroxfb MMIO
  e9000000-e97fffff : Matrox Graphics, Inc. MGA 2164W [Millennium II] A=
GP
ec000000-ecffffff : PCI Bus #01
  ec000000-ecffffff : Matrox Graphics, Inc. MGA 2164W [Millennium II] A=
GP
    ec000000-ecffffff : matroxfb FB
f0000000-f000007f : 3Com Corporation 3c905C-TX/TX-M [Tornado] (#2)
f0001000-f000107f : 3Com Corporation 3c905C-TX/TX-M [Tornado]
f0002000-f0002fff : Adaptec AIC-7861
  f0002000-f0002fff : aic7xxx
f0003000-f000303f : AVM Audiovisuelles MKTG & Computer System GmbH B1 I=
SDN
ffff0000-ffffffff : reserved


> [7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corp. 440LX/EX - 82443LX/EX Host bridge (rev=
 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort+ >SERR- <PERR-
	Latency: 64
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=3D128M]
	Capabilities: [a0] AGP version 1.0
		Status: RQ=3D31 SBA+ 64bit- FW- Rate=3Dx1,x2
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>

00:01.0 PCI bridge: Intel Corp. 440LX/EX - 82443LX/EX AGP bridge (rev 0=
3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: e8000000-ebffffff
	Prefetchable memory behind bridge: ec000000-ecffffff
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:07.0 ISA bridge: Intel Corp. 82371AB PIIX4 ISA (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 IDE interface: Intel Corp. 82371AB PIIX4 IDE (rev 01) (prog-if =
80 [Master])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Region 4: I/O ports at f000 [disabled] [size=3D16]

00:07.2 USB Controller: Intel Corp. 82371AB PIIX4 USB (rev 01) (prog-if=
 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at d000 [size=3D32]

00:07.3 Bridge: Intel Corp. 82371AB PIIX4 ACPI (rev 01)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 9

00:09.0 Network controller: AVM Audiovisuelles MKTG & Computer System G=
mbH B1 ISDN (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 500ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0003000 (32-bit, non-prefetchable) [size=3D64]
	Region 1: I/O ports at d400 [size=3D64]
	Region 2: I/O ports at d800 [size=3D32]

00:0b.0 Ethernet controller: 3Com Corporation 3c905C-TX [Fast Etherlink=
] (rev 74)
	Subsystem: 3Com Corporation 3C905C-TX Fast Etherlink for PC Management=
 NIC
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), cache line size 08
	Interrupt: pin A routed to IRQ 12
	Region 0: I/O ports at dc00 [size=3D128]
	Region 1: Memory at f0001000 (32-bit, non-prefetchable) [size=3D128]
	Expansion ROM at ed000000 [disabled] [size=3D128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

00:0d.0 Ethernet controller: 3Com Corporation 3c905C-TX [Fast Etherlink=
] (rev 74)
	Subsystem: 3Com Corporation 3C905C-TX Fast Etherlink for PC Management=
 NIC
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), cache line size 08
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at e000 [size=3D128]
	Region 1: Memory at f0000000 (32-bit, non-prefetchable) [size=3D128]
	Expansion ROM at ee000000 [disabled] [size=3D128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

00:0f.0 SCSI storage controller: Adaptec AIC-7861 (rev 01)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (1000ns min, 1000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at e400 [disabled] [size=3D256]
	Region 1: Memory at f0002000 (32-bit, non-prefetchable) [size=3D4K]
	Expansion ROM at ef000000 [disabled] [size=3D64K]

01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2164W [Mil=
lennium II] AGP (prog-if 00 [VGA])
	Subsystem: Matrox Graphics, Inc. MGA 2164W [Millennium II] AGP
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at ec000000 (32-bit, prefetchable) [size=3D16M]
	Region 1: Memory at e8000000 (32-bit, non-prefetchable) [size=3D16K]
	Region 2: Memory at e9000000 (32-bit, non-prefetchable) [size=3D8M]
	Expansion ROM at <unassigned> [disabled] [size=3D64K]
	Capabilities: [f0] AGP version 1.0
		Status: RQ=3D0 SBA- 64bit- FW- Rate=3D<none>
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>



> [7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:=20
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: QUANTUM  Model: FIREBALL ST6.4S  Rev: 0F0C
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: PIONEER  Model: CD-ROM DR-U03S   Rev: 1.01
  Type:   CD-ROM                           ANSI SCSI revision: 02

> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):

master@home:/usr/src/kernel-source-2.4.20$ cat /proc/scsi/aic7xxx/0=20
Adaptec AIC7xxx driver version: 6.2.8
aic7860: Ultra Single Channel A, SCSI Id=3D7, 3/253 SCBs

Serial EEPROM:
0x0258 0x0258 0x0218 0x0258 0x0258 0x0258 0x0258 0x0258=20
0x0238 0x0238 0x0238 0x0238 0x0238 0x0238 0x0238 0x0238=20
0x18b6 0x0057 0x2807 0x0008 0xffff 0xffff 0xffff 0xffff=20
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x6551=20

Channel A Target 0 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)
	Goal: 20.000MB/s transfers (20.000MHz, offset 15)
	Curr: 20.000MB/s transfers (20.000MHz, offset 15)
	Channel A Target 0 Lun 0 Settings
		Commands Queued 15404
		Commands Active 0
		Command Openings 6
		Max Tagged Openings 253
		Device Queue Frozen Count 0
Channel A Target 1 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)
Channel A Target 2 Negotiation Settings
	User: 10.000MB/s transfers (10.000MHz, offset 255)
	Goal: 10.000MB/s transfers (10.000MHz, offset 8)
	Curr: 3.300MB/s transfers
	Channel A Target 2 Lun 0 Settings
		Commands Queued 1
		Commands Active 0
		Command Openings 1
		Max Tagged Openings 0
		Device Queue Frozen Count 0
Channel A Target 3 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)
Channel A Target 4 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)
Channel A Target 5 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)
Channel A Target 6 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)
Channel A Target 7 Negotiation Settings
	User: 20.000MB/s transfers (20.000MHz, offset 255)

> [X.] Other notes, patches, fixes, workarounds:

I'm using the Debian version of the kernel. Here is what the
README.Debian says:

kernel-source for DEBIAN
------------------------

These patches were applied:

* NFS client seekdir patch
  http://www.fys.uio.no/~trondmy/src/
* SCSI Media Changer
  http://bytesex.org/patches/
* Big Physical Area Reservation
  http://www.polyware.nl/~middelin/hob-v4l.html#bigphysarea

These modifications were also made:

* Fixed a couple of argument processing bugs in main.c (Eric Delaunay).
* Added initrd support for cramfs in init/do_mounts.c.
* Exported proc_get_inode.
* Fixed pegasus_set_multicast lockup.
* Fixed dead lock on shutdown in 8139too.
* Don't kill page cache entries in set_blocksize.
* Added support for nm256xl+ (Mattia Monga).
* Fixed handling of HIDs with product strings bug no manufacturer.
* Fixed the use of return values from mem*_io in drivers/isdn/sc.
* Added missing headers in drivers/pcmcia/i82092.c.
* Added missing headers in drivers/isdn/hisax/avma1_cs.c.
* Fixed compile error in drivers/scsi/dpt_i2o.c on alpha.
* Removed -g from driviers/atm/Makefile.
* Extern inline -> static inline in drivers/net/hamradio/soundmodem.
* Added asm/io.h for in*/out* to drivers/net/wan/farsync.c.
* Corrected AdvWriteDWordLramNoSwap in drivers/scsi/advansys.c.
* Added check for VIA KT266 IO-APIC in arch/i386/kernel/io_apic.c.
* Fix slashes in broken Acorn ISO9660 images in fs/isofs/dir.c (Darren =
Salt).
* ip_nat_{ftp,irc} cannot be m if ip_conntrack_{ftp,irc} is y, respecti=
vely.
* Always call complete after unlinking an urb in drivers/usb/usb-ohci.c=
=2E
* Set hardsect size to 512 in drivers/scsi/sr.c.
* Set ?time to zero in fs/cramfs/inode.c.
* Allow ACPI to be compiled as a module.
* Fixed umsdos_solve_hlink oops in fs/umsdos/dir.c.
* Honour ide?=3Ddma in drivers/ide/via82cxxx.c (Arne Nordmark).
* Removed period check for executables in fs/isofs/inode.c.
* Disable CONFIG_VIDEO_VESA unless VESA FB support is turned on.
* Modularised VESA FB.
* Fixed i386 lcall DoS (Petr Vandrovec).
* Replaced BUG() with printk() in fs/fat/file.c.
* Fixed circular dependency in include/linux/netfilter_ipv4/ip_conntrac=
k.h.
* Do not get seqno if we will not use it in fs/isofs/inode.c.
* Added missing semicolons in drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
  (Michael Osamu Shiobara).
* Made CONFIG_PARIDE_EPATC8 into a runtime option.
* Fixed double PCI unregistration in drivers/char/joystick/pcigame.c.
* Include linux/init.h in drivers/char/amd76x_pm.c.
* Include linux/init.h in drivers/scsi/cpqfcTSinit.c.
* Removed CONFIG_INET_ECN check in net/ipv4/tcp_diag.c.
* Fixed stxncpy on alpha (2.4.21pre1).
* Fixed ext3 data=3Djournal umount problem (2.4.21pre1).
* Added dependency on MTD_CONCAT for sc520cdp.
* Fixed ext3 remount deadlock added in 2.4.20-2 (Andrew Morton).
* Fixed ext3 use-after-free bug (Andrew Morton).
* Fixed i845G AGP Gart initialisation (Michael Milligan).
* Updated i810_audio driver (2.4.21pre1).

Changes to comments and documentation:

* Fixed a typo in Documentation/sound/VIBRA16 (Carlos Valdivia Yag=FCe)=
=2E
* Fixed a typo in Documentation/sound/OPL3-SA (Carlos Valdivia Yag=FCe)=
=2E
* Fixed comment about epochs in arch/alpha/kernel/time.c.

Non-free bits removed:

* Keyspan firmware.
* SMC Token Ring firmware, driver disabled.
* ACENIC firwmare, driver disabled.
* DGRS firmware, driver disabled.
* DAB firmware, driver disabled.

Herbert Xu <herbert@debian.org>
$Id: README.Debian,v 1.63 2002/12/21 02:50:04 herbert Exp $


Additionally, I applied the USAGI IPv6 patch snapshot of 2003/01/06

--=20
Lionel
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
