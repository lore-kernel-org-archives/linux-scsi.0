From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15283] New: PROBLEM: kernel 2.6.32-7 will not boot -- could not
 find /dev/root Dell Vostro 1000
Date: Fri, 12 Feb 2010 12:58:06 GMT
Message-ID: <bug-15283-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56986 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0BLM6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 07:58:09 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1CCw6Pm010881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2010 12:58:06 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D15283

           Summary: PROBLEM: kernel 2.6.32-7 will not boot -- could not
                    find /dev/root Dell Vostro 1000
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: imran.javeed@vocalink.com
        Regression: No


Created an attachment (id=3D25002)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=3D25002)
=2Econfig file from kernel build

[1.] One line summary of the problem: Upgrade to 2.6.32-7 will not boot=
(cannot
recognize disk)


[2.] Full description of the problem/report:

I am trying to upgrade my kernel from 2.6.18-53 to 2.6.32-7, the proble=
m i am
having is that the 2.6.32 kernel will not recognize my SATA disk. I hav=
e a Dell
Vostro 1000 & have happily been using linux(centos5) with no issues.

Ive ensured the correct options have been set in .config, included liba=
ta, ahci
within the kernel(they are not modules) and checked various other infor=
mation
sources on the net, but it still does not work.(this is the 3rd night n=
ow &
still no fix)

Hence my email to you to try & fix for me please?

Attached is the information you require

[3.] Keywords (i.e., modules, networking, kernel):
SATA SB600 ATI

[4.] Kernel information
2.6.32-7
[4.1.] Kernel version (from /proc/version):
CURRENT_VERSION =3D=3D Linux version 2.6.18-53.el5PAE
(mockbuild@builder6.centos.org) (gcc version 4.1.2 20070626 (Red Hat 4.=
1.2-14))
#1 SMP Mon Nov 12 02:55:09 EST 2007

[4.2.] Kernel .config file:
Attached

[5.] Most recent kernel version which did not have the bug:
That im using right now 2.6.18-53

[6.] Output of Oops.. message (if applicable) with symbolic information
=C2=A0=C2=A0=C2=A0=C2=A0 resolved (see Documentation/oops-tracing.txt) =
N/A

[7.] A small shell script or example program which triggers the
=C2=A0=C2=A0=C2=A0=C2=A0 problem (if possible)
N/A

[8.] Environment

[8.1.] Software (add the output of the ver_linux script here) Linux uhu=
d
2.6.18-53.el5PAE #1 SMP Mon Nov 12 02:55:09 EST 2007 i686 athlon i386 G=
NU/Linux

Gnu C=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.1.2
Gnu make=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 3.81
binutils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 2.17.50.0.6
util-linux=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 2.13-pre7
mount=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.13-pre7
module-init-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.3-pre2
e2fsprogs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1.39
pcmciautils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 014
quota-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 3.13.
PPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.4.4
isdn4k-utils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 3.9
Linux C Library=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.5
Dynamic linker (ldd)=C2=A0=C2=A0 2.5
Procps=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.2.7
Net-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1.60
Kbd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.12
oprofile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0.9.2
Sh-utils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 5.97
udev=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 095
wireless-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 28
Modules Loaded=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndiswrap=
per bridge vboxnetflt vboxdrv hidp l2cap
bluetooth configfs sunrpc ip_conntrack_netbios_ns ipt_MASQUERADE iptabl=
e_nat
ip_nat ipt_LOG ipt_REJECT xt_state ip_conntrack nfnetlink xt_multiport
iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tabl=
es
x_tables ipv6 cpufreq_ondemand dm_mirror dm_multipath dm_mod video sbs
backlight i2c_ec button battery asus_acpi ac parport_pc lp parport
snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss joydev snd_seq_mi=
di_event
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm ide_cd b44 =
cdrom
snd_timer snd i2c_piix4 mii k8_edac i2c_core k8temp edac_mc soundcore h=
wmon
serio_raw sdhci mmc_core snd_page_alloc ahci libata sd_mod scsi_mod ext=
3 jbd
ehci_hcd ohci_hcd uhci_hcd


[8.2.] Processor information (from /proc/cpuinfo):
processor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
vendor_id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AuthenticAMD
cpu family=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 15
model=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 104
model name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AMD Turion(tm) 64 X2 Mobile =
Technology TL-60 stepping=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
: 2 cpu MHz=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 800.000 c=
ache size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 512 KB physical id=C2=A0=C2=A0=
=C2=A0=C2=A0 : 0
siblings=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2 core id=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0 cpu cores=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 : 2 fdiv_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 :
no hlt_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no f00f_bu=
g=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no coma_bug=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no fpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0 : yes fpu_exception=C2=A0=C2=A0 : yes cpuid level=C2=A0=C2=A0=C2=
=A0=C2=A0 : 1 wp=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 : yes flags=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : fpu vme de pse tsc msr pae=
 mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy 3dnowp=
refetch
ts fid vid ttp tm stc 100mhzsteps bogomips=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 : 1601.16

processor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1
vendor_id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AuthenticAMD
cpu family=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 15
model=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 104
model name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AMD Turion(tm) 64 X2 Mobile =
Technology TL-60 stepping=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
: 2 cpu MHz=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 800.000 c=
ache size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 512 KB physical id=C2=A0=C2=A0=
=C2=A0=C2=A0 : 0
siblings=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2 core id=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1 cpu cores=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 : 2 fdiv_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 :
no hlt_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no f00f_bu=
g=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no coma_bug=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no fpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0 : yes fpu_exception=C2=A0=C2=A0 : yes cpuid level=C2=A0=C2=A0=C2=
=A0=C2=A0 : 1 wp=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 : yes flags=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : fpu vme de pse tsc msr pae=
 mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy 3dnowp=
refetch
ts fid vid ttp tm stc 100mhzsteps bogomips=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 : 1601.16

[8.3.] Module information (from /proc/modules):

ndiswrapper 169360 0 - Live 0xf9023000
bridge 53341 0 - Live 0xf8d9b000
vboxnetflt 79400 0 - Live 0xf8d86000
vboxdrv 103208 1 vboxnetflt, Live 0xf8d6b000 hidp 23105 2 - Live 0xf8d0=
d000
l2cap 29633 5 hidp, Live 0xf8d04000 bluetooth 53925 2 hidp,l2cap, Live
0xf8d3e000 configfs 28753 1 - Live 0xf8cfb000 sunrpc 144253 1 - Live 0x=
f8d19000
ip_conntrack_netbios_ns 6977 0 - Live 0xf8c84000 ipt_MASQUERADE 7745 3 =
- Live
0xf8c72000 iptable_nat 11205 1 - Live 0xf8ced000 ip_nat 20973 2
ipt_MASQUERADE,iptable_nat, Live 0xf8cd5000 ipt_LOG 10177 1 - Live 0xf8=
c78000
ipt_REJECT 9537 8 - Live 0xf8c7c000 xt_state 6209 7 - Live 0xf8c75000
ip_conntrack 53025 5
ip_conntrack_netbios_ns,ipt_MASQUERADE,iptable_nat,ip_nat,xt_state, Liv=
e
0xf8cc7000 nfnetlink 10713 2 ip_nat,ip_conntrack, Live 0xf8c51000 xt_mu=
ltiport
7233 1 - Live 0xf8c5f000 iptable_filter 7105 1 - Live 0xf8c5c000 ip_tab=
les
17029 2 iptable_nat,iptable_filter, Live 0xf8c62000 ip6t_REJECT 9409 1 =
- Live
0xf8c58000 xt_tcpudp 7105 53 - Live 0xf8c55000 ip6table_filter 6849 1 -=
 Live
0xf8c3e000 ip6_tables 18181 1 ip6table_filter, Live 0xf8c4b000 x_tables=
 17349
10
ipt_MASQUERADE,iptable_nat,ipt_LOG,ipt_REJECT,xt_state,xt_multiport,ip_=
tables,ip
6t_REJECT,xt_tcpudp,ip6_tables, Live 0xf8c45000
ipv6 251393 21 ip6t_REJECT, Live 0xf8c88000 cpufreq_ondemand 10573 1 - =
Live
0xf8a35000 dm_mirror 28869 0 - Live 0xf8a3a000 dm_multipath 21577 0 - L=
ive
0xf89ee000 dm_mod 58457 2 dm_mirror,dm_multipath, Live 0xf8a43000 video=
 19269 0
- Live 0xf89f5000 sbs 18533 0 - Live 0xf89c2000 backlight 10049 0 - Liv=
e
0xf89ea000 i2c_ec 9025 1 sbs, Live 0xf89e6000 button 10705 0 - Live 0xf=
89e2000
battery 13637 0 - Live 0xf89c8000 asus_acpi 19289 0 - Live 0xf896c000 a=
c 9157 0
- Live 0xf8995000 parport_pc 29157 0 - Live 0xf89d9000 lp 15849 0 - Liv=
e
0xf89ad000 parport 37513 2 parport_pc,lp, Live 0xf89ce000 snd_hda_intel=
 24025 0
- Live 0xf89bb000 snd_hda_codec 202689 1 snd_hda_intel, Live 0xf89fd000
snd_seq_dummy 7877 0 - Live 0xf8992000 snd_seq_oss 32577 0 - Live 0xf89=
b2000
joydev 13313 0 - Live 0xf898d000 snd_seq_midi_event 11073 1 snd_seq_oss=
, Live
0xf8989000 snd_seq 49713 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event=
, Live
0xf8999000 snd_seq_device 11725 3 snd_seq_dummy,snd_seq_oss,snd_seq, Li=
ve
0xf8985000 snd_pcm_oss 42945 0 - Live 0xf893b000 snd_mixer_oss 19009 1
snd_pcm_oss, Live 0xf8966000 sg 35933 0 - Live 0xf895c000 snd_pcm 72133=
 3
snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8972000 ide_cd 40033 0=
 - Live
0xf8951000
b44 29133 0 - Live 0xf891c000
cdrom 36705 1 ide_cd, Live 0xf8947000
snd_timer 24645 2 snd_seq,snd_pcm, Live 0xf8925000 snd 52421 9
snd_hda_intel,snd_hda_codec,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_=
oss,snd_m
ixer_oss,snd_pcm,snd_timer, Live 0xf892d000
i2c_piix4 12237 0 - Live 0xf8902000
mii 9409 1 b44, Live 0xf88fe000
k8_edac 18177 0 - Live 0xf8916000
i2c_core 23745 2 i2c_ec,i2c_piix4, Live 0xf890f000 k8temp 9537 0 - Live
0xf88db000 edac_mc 24977 1 k8_edac, Live 0xf8907000 soundcore 11553 1 s=
nd, Live
0xf88d7000 hwmon 7365 1 k8temp, Live 0xf88d4000 serio_raw 10693 0 - Liv=
e
0xf88c8000 sdhci 21337 0 - Live 0xf8846000 mmc_core 27457 1 sdhci, Live
0xf88cc000 snd_page_alloc 13769 2 snd_hda_intel,snd_pcm, Live 0xf88be00=
0 ahci
23621 2 - Live 0xf885f000 libata 115961 1 ahci, Live 0xf88e0000 sd_mod =
24897 3
- Live 0xf8857000 scsi_mod 132685 3 sg,libata,sd_mod, Live 0xf8879000
ext3 123337 1 - Live 0xf889e000
jbd 56553 1 ext3, Live 0xf886a000
ehci_hcd 33229 0 - Live 0xf884d000
ohci_hcd 23389 0 - Live 0xf8837000
uhci_hcd 25549 0 - Live 0xf882f000


[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iom=
em)
000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
0220-022f : pnp 00:08
03c0-03df : vga+
03f6-03f6 : ide0
1080-1080 : motherboard
=C2=A0 1080-1080 : pnp 00:08
8000-805f : motherboard
=C2=A0 8000-8003 : ACPI PM1a_EVT_BLK
=C2=A0 8004-8005 : ACPI PM1a_CNT_BLK
=C2=A0 8008-800b : ACPI PM_TMR
=C2=A0 8010-8015 : ACPI CPU throttle
=C2=A0 8020-8027 : ACPI GPE0_BLK
8200-8200 : ACPI PM2_CNT_BLK
8204-8207 : ACPI PM1b_EVT_BLK
8400-840f : 0000:00:12.0
8410-841f : 0000:00:14.0
=C2=A0 8410-8417 : piix4_smbus
8420-842f : 0000:00:14.1
=C2=A0 8420-8427 : ide0
8430-8437 : 0000:00:12.0
8438-843f : 0000:00:12.0
8450-8453 : 0000:00:12.0
8454-8457 : 0000:00:12.0
9000-9fff : PCI Bus #01
=C2=A0 9000-90ff : 0000:01:05.0
################################
00000000-0009dbff : System RAM
=C2=A0 00000000-00000000 : Crash kernel
0009dc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000cd000-000cdfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-a7e6ffff : System RAM
=C2=A0 00400000-006075e0 : Kernel code
=C2=A0 006075e1-006de9bb : Kernel data
a7e70000-a7e7ffff : ACPI Tables
a7e80000-a7efffff : ACPI Non-volatile Storage a7f00000-afffffff : reser=
ved
c0000000-c0003fff : 0000:00:14.2
=C2=A0 c0000000-c0003fff : ICH HD audio
c0004000-c00043ff : 0000:00:12.0
=C2=A0 c0004000-c00043ff : ahci
c0004400-c00044ff : 0000:00:13.5
=C2=A0 c0004400-c00044ff : ehci_hcd
c0005000-c0005fff : 0000:00:13.0
=C2=A0 c0005000-c0005fff : ohci_hcd
c0006000-c0006fff : 0000:00:13.1
=C2=A0 c0006000-c0006fff : ohci_hcd
c0007000-c0007fff : 0000:00:13.2
=C2=A0 c0007000-c0007fff : ohci_hcd
c0008000-c0008fff : 0000:00:13.3
=C2=A0 c0008000-c0008fff : ohci_hcd
c0009000-c0009fff : 0000:00:13.4
=C2=A0 c0009000-c0009fff : ohci_hcd
c0100000-c01fffff : PCI Bus #01
=C2=A0 c0100000-c010ffff : 0000:01:05.0
=C2=A0 c0120000-c013ffff : 0000:01:05.0
c0200000-c02fffff : PCI Bus #05
=C2=A0 c0200000-c0203fff : 0000:05:00.0
=C2=A0=C2=A0=C2=A0 c0200000-c0203fff : ndiswrapper
c0300000-c03fffff : PCI Bus #08
=C2=A0 c0300000-c0301fff : 0000:08:00.0
=C2=A0=C2=A0=C2=A0 c0300000-c0301fff : b44
=C2=A0 c0302800-c03028ff : 0000:08:01.0
=C2=A0=C2=A0=C2=A0 c0302800-c03028ff : sdhci:slot0
=C2=A0 c0302c00-c0302cff : 0000:08:01.1
c8000000-cfffffff : PCI Bus #01
=C2=A0 c8000000-cfffffff : 0000:01:05.0
e0000000-efffffff : reserved
fec00000-fec0ffff : reserved
fed00000-fed003ff : 0000:00:14.0
fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-14fffffff : System RAM



[8.5.] PCI information ('lspci -vvv' as root) 00:00.0 Host bridge: ATI
Technologies Inc RS480 Host Bridge (rev 10)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort+ <MAbort+ >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64

00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [=
Normal
decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=
=3D01, subordinate=3D01, sec-latency=3D64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 00009000-=
00009fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: c01000=
00-c01fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind b=
ridge: 00000000c8000000-00000000cff00000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz+ Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR- NoI=
SA+ VGA+ MAbort- >Reset- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [44] HyperTran=
sport: MSI Mapping
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] #0d [0000=
]

00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [=
Normal
decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size:=
 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=
=3D02, subordinate=3D04, sec-latency=3D0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 0000f000-=
00000fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: fff000=
00-000fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind b=
ridge: 00000000fff00000-0000000000000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR- NoI=
SA+ VGA- MAbort- >Reset- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Man=
agement version 3
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [58] Express R=
oot Port (Slot+) IRQ 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Supported: MaxPayload 128 bytes, PhantFunc 0=
, ExtTag+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1=
, Port 247
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Speed 2.5Gb/s, Width x16
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+=
 Surpise+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: Number 0, PowerLimit 0.000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-=
 HPIrq-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: AttnInd Off, PwrInd Off, Power-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Root: Correctable- Non-Fatal- Fatal- PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Message S=
ignalled Interrupts: 64bit- Queue=3D0/0
Enable-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Address: 00000000=C2=A0 Data: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] #0d [0000=
]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b8] HyperTran=
sport: MSI Mapping

00:06.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [=
Normal
decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size:=
 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=
=3D05, subordinate=3D07, sec-latency=3D0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 0000f000-=
00000fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: c02000=
00-c02fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind b=
ridge: 00000000fff00000-0000000000000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR- NoI=
SA+ VGA- MAbort- >Reset- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Man=
agement version 3
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [58] Express R=
oot Port (Slot+) IRQ 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Supported: MaxPayload 128 bytes, PhantFunc 0=
, ExtTag+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1=
, Port 3
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Speed 2.5Gb/s, Width x1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+=
 Surpise+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: Number 0, PowerLimit 25.000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-=
 HPIrq-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Slot: AttnInd Off, PwrInd Off, Power-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Root: Correctable- Non-Fatal- Fatal- PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Message S=
ignalled Interrupts: 64bit- Queue=3D0/0
Enable-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Address: 00000000=C2=A0 Data: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] #0d [0000=
]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b8] HyperTran=
sport: MSI Mapping

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA (pr=
og-if 01
[AHCI 1.0])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort+
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to I=
RQ 209
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at 8438 =
[size=3D8]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: I/O ports at 8454 =
[size=3D4]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: I/O ports at 8430 =
[size=3D8]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 3: I/O ports at 8450 =
[size=3D4]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 4: I/O ports at 8400 =
[size=3D16]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 5: Memory at c0004000=
 (32-bit, non-prefetchable) [size=3D1K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [60] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if=
 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to I=
RQ 177
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0005000=
 (32-bit, non-prefetchable) [size=3D4K]

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if=
 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to I=
RQ 185
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0006000=
 (32-bit, non-prefetchable) [size=3D4K]

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if=
 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin C routed to I=
RQ 193
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0007000=
 (32-bit, non-prefetchable) [size=3D4K]

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if=
 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to I=
RQ 185
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0008000=
 (32-bit, non-prefetchable) [size=3D4K]

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if=
 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin C routed to I=
RQ 193
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0009000=
 (32-bit, non-prefetchable) [size=3D4K]

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI=
)
(prog-if 20 [EHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 64 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin D routed to I=
RQ 201
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0004400=
 (32-bit, non-prefetchable) [size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [c0] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Bridge: PM- B3+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [e4] Debug por=
t

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at 8410 =
[size=3D16]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: Memory at fed00000=
 (32-bit, non-prefetchable) [size=3D1K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] HyperTran=
sport: MSI Mapping

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a [Mast=
er SecP
PriP])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem- BusMaster=
+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to I=
RQ 177
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at <igno=
red>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: I/O ports at <igno=
red>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: I/O ports at <unas=
signed>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 3: I/O ports at <unas=
signed>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 4: I/O ports at 8420 =
[size=3D16]

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin ? routed to I=
RQ 177
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0000000=
 (64-bit, non-prefetchable) [size=3D16K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-=
if 01
[Subtractive decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=
=3D08, subordinate=3D0a, sec-latency=3D64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 0000f000-=
00000fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: c03000=
00-c03fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind b=
ridge: fff00000-000fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR+ NoI=
SA+ VGA- MAbort- >Reset- FastB2B-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster=
- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] HyperTran=
sport: Host or Secondary Interface
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 !!! Possibly incomplete decoding
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Command: WarmRst+ DblEnd-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TX=
O-
<CRCErr=3D8
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit L=
WO=3D16bit
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 Address
Map
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster=
- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 DRAM
Controller
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster=
- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster=
- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [f0] #0f [0010=
]

01:05.0 VGA compatible controller: ATI Technologies Inc RS482 [Radeon X=
press
200] (prog-if 00 [VGA])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- Fas=
tB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 255 (2000ns min), C=
ache Line Size: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to I=
RQ 10
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c8000000=
 (32-bit, prefetchable) [size=3D128M]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: I/O ports at 9000 =
[size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: Memory at c0100000=
 (32-bit, non-prefetchable) [size=3D64K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [virtual] Expansion ROM at c=
0120000 [disabled] [size=3D128K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan mini-=
PCI (rev
01)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 0007
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size:=
 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to I=
RQ 193
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0200000=
 (32-bit, non-prefetchable) [size=3D16K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [40] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [58] Message S=
ignalled Interrupts: 64bit- Queue=3D0/0
Enable-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Address: 00000000=C2=A0 Data: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [d0] Express L=
egacy Endpoint IRQ 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Supported: MaxPayload 128 bytes, PhantFunc 0=
, ExtTag+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Latency L0s <4us, L1 unlimited
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: AtnBtn- AtnInd- PwrInd-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: Errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, P=
ort 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Latency L0s <4us, L1 <64us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Link: Speed 2.5Gb/s, Width x1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [100] Advanced=
 Error Reporting
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [13c] Virtual =
Channel

08:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX=
 (rev
02)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to I=
RQ 225
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0300000=
 (32-bit, non-prefetchable) [size=3D8K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [40] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

08:01.0 Class 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapt=
er (rev
22)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to I=
RQ 217
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0302800=
 (32-bit, non-prefetchable) [size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

08:01.1 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev=
 12)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown devi=
ce 022a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster=
+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fas=
tB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size=
: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to I=
RQ 9
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0302c00=
 (32-bit, non-prefetchable) [size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Power Man=
agement version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-


[8.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
=C2=A0 Vendor: ATA=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Model: FUJITSU MHY2160=
B Rev: 0085
=C2=A0 Type:=C2=A0=C2=A0 Direct-Access=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ANSI SCSI revision: 05

[8.7.] Other information that might be relevant to the problem
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (please look in /proc and include =
all information that you
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 think to be relevant):
[X.] Other notes, patches, fixes, workarounds:Hello

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
