From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Wed, 22 May 2002 09:49:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CEB4D6D.92C207EE@cri74.org>
References: <3CEA83AE.1DCAB7BC@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Lorraine Suschetet <lorraine@ext.cri74.org>

=46abien Salvi wrote:
>=20
> Hello, I have problem when using the lk 2.4
>=20
> My system :
> - A bi-pentium II 450 processor with 1 GB RAM
> - Symbios/LSILogic SCSI card NCR 53c895
> - external Mylex DAC960SX RAID Controller (Ultra2 scsi) in a Siemens
> enclosure
>=20
> 1) With kernel 2.2 (exactly 2.2.19, but it's the same through 2.2.9 t=
o
> 2.2.19), I have no problems, my disks are visible without problems :
>=20
> May 17 16:22:28 node01 kernel: sym53c8xx: at PCI bus 2, device 8,
> function 0
> May 17 16:22:28 node01 kernel: sym53c8xx: 53c876 detected with Symbio=
s
> NVRAM
> May 17 16:22:28 node01 kernel: sym53c8xx: at PCI bus 2, device 8,
> function 1
> May 17 16:22:28 node01 kernel: sym53c8xx: 53c876 detected with Symbio=
s
> NVRAM
> May 17 16:22:28 node01 kernel: sym53c8xx: at PCI bus 2, device 1,
> function 0
> May 17 16:22:28 node01 kernel: sym53c8xx: 53c895 detected with Symbio=
s
> NVRAM
> May 17 16:22:28 node01 kernel: sym53c876-0: rev 0x14 on pci bus 2 dev=
ice
> 8 function 0 irq 15
> May 17 16:22:28 node01 kernel: sym53c876-0: Symbios format NVRAM, ID =
7,
> Fast-20, Parity Checking
> May 17 16:22:28 node01 kernel: sym53c876-0: on-chip RAM at 0xf4202000
> May 17 16:22:28 node01 kernel: sym53c876-0: restart (scsi reset).
> May 17 16:22:28 node01 kernel: sym53c876-0: Downloading SCSI SCRIPTS.
> May 17 16:22:28 node01 kernel: sym53c876-1: rev 0x14 on pci bus 2 dev=
ice
> 8 function 1 irq 5
> May 17 16:22:28 node01 kernel: sym53c876-1: Symbios format NVRAM, ID =
7,
> Fast-20, Parity Checking
> May 17 16:22:28 node01 kernel: sym53c876-1: on-chip RAM at 0xf4203000
> May 17 16:22:28 node01 kernel: sym53c876-1: restart (scsi reset).
> May 17 16:22:28 node01 kernel: sym53c876-1: Downloading SCSI SCRIPTS.
> May 17 16:22:28 node01 kernel: sym53c895-2: rev 0x1 on pci bus 2 devi=
ce
> 1 function 0 irq 10
> May 17 16:22:28 node01 kernel: sym53c895-2: Symbios format NVRAM, ID =
7,
> Fast-40, Parity Checking
> May 17 16:22:28 node01 kernel: sym53c895-2: on-chip RAM at 0xf4201000
> May 17 16:22:28 node01 kernel: sym53c895-2: restart (scsi reset).
> May 17 16:22:28 node01 kernel: sym53c895-2: Downloading SCSI SCRIPTS.
> May 17 16:22:28 node01 kernel: ncr53c8xx: at PCI bus 2, device 8,
> function 0
> May 17 16:22:28 node01 kernel: ncr53c8xx: IO region 0x2400[0..127] is=
 in
> use
> May 17 16:22:28 node01 kernel: ncr53c8xx: at PCI bus 2, device 8,
> function 1
> May 17 16:22:28 node01 kernel: ncr53c8xx: IO region 0x2800[0..127] is=
 in
> use
> May 17 16:22:28 node01 kernel: ncr53c8xx: at PCI bus 2, device 1,
> function 0
> May 17 16:22:28 node01 kernel: ncr53c8xx: IO region 0x2000[0..127] is=
 in
> use
> May 17 16:22:28 node01 kernel: scsi0 : sym53c8xx-1.7.1-20000726
> May 17 16:22:28 node01 kernel: scsi1 : sym53c8xx-1.7.1-20000726
> May 17 16:22:28 node01 kernel: scsi2 : sym53c8xx-1.7.1-20000726
> May 17 16:22:28 node01 kernel: scsi : 3 hosts.
> May 17 16:22:28 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:22:28 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:22:28 node01 kernel: Detected scsi disk sda at scsi0, chann=
el
> 0, id 0, lun 0
> May 17 16:22:28 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:22:28 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:22:28 node01 kernel: Detected scsi disk sdb at scsi0, chann=
el
> 0, id 0, lun 1
> May 17 16:22:28 node01 kernel: sym53c876-0-<0,0>: tagged command queu=
e
> depth set to 8
> May 17 16:22:28 node01 kernel: sym53c876-0-<0,1>: tagged command queu=
e
> depth set to 8
> May 17 16:22:28 node01 kernel:   Vendor: NEC       Model: CD-ROM
> DRIVE:466  Rev: 1.17
> May 17 16:22:28 node01 kernel:   Type:
> CD-ROM                             ANSI SCSI revision: 02
> May 17 16:22:28 node01 kernel: Detected scsi CD-ROM sr0 at scsi2,
> channel 0, id 5, lun 0
> May 17 16:22:28 node01 kernel:   Vendor: SIEMENS   Model: STM/L
> S1          Rev: 4.1b
> May 17 16:22:28 node01 kernel:   Type:
> Processor                          ANSI SCSI revision: 02
> May 17 16:22:28 node01 kernel: Detected scsi generic sg3 at scsi2,
> channel 0, id 8, lun 0
> May 17 16:22:28 node01 kernel: scsi : detected 4 SCSI generics 1 SCSI
> cdrom 2 SCSI disks total.
> May 17 16:22:28 node01 kernel: sym53c895-2-<5,*>: FAST-20 SCSI 20.0 M=
B/s
> (50 ns, offset 16)
> May 17 16:22:28 node01 kernel: sr0: scsi3-mmc drive: 17x/40x cd/rw
> xa/form2 cdda tray
> May 17 16:22:28 node01 kernel: Uniform CD-ROM driver Revision: 3.11
> May 17 16:22:28 node01 kernel: sym53c876-0-<0,*>: FAST-20 SCSI 20.0 M=
B/s
> (50 ns, offset 16)
> May 17 16:22:28 node01 kernel: SCSI device sda: hdwr sector=3D 512 by=
tes.
> Sectors=3D 17776640 [8680 MB] [8.7 GB]
> May 17 16:22:28 node01 kernel: SCSI device sdb: hdwr sector=3D 512 by=
tes.
> Sectors=3D 17776640 [8680 MB] [8.7 GB]
>=20
> It founds the real 2 disks exporting from the RAID controller (in fac=
t
> 2*2 disks in RAID 1)
>=20
> 2) with 2.4.18 kernel, I've got this :
> May 17 16:19:36 node01 kernel: sym0: <875> rev 0x14 on pci bus 2 devi=
ce
> 8 function 0 irq 15
> May 17 16:19:36 node01 kernel: sym0: Symbios NVRAM, ID 7, Fast-20, HV=
D,
> parity checking
> May 17 16:19:36 node01 kernel: sym0: open drain IRQ line driver, usin=
g
> on-chip SRAM
> May 17 16:19:36 node01 kernel: sym0: using LOAD/STORE-based firmware.
> May 17 16:19:36 node01 kernel: sym0: SCSI BUS has been reset.
> May 17 16:19:36 node01 kernel: sym1: <875> rev 0x14 on pci bus 2 devi=
ce
> 8 function 1 irq 5
> May 17 16:19:36 node01 kernel: sym1: Symbios NVRAM, ID 7, Fast-20, HV=
D,
> parity checking
> May 17 16:19:36 node01 kernel: sym1: open drain IRQ line driver, usin=
g
> on-chip SRAM
> May 17 16:19:36 node01 kernel: sym1: using LOAD/STORE-based firmware.
> May 17 16:19:36 node01 kernel: sym1: SCSI BUS has been reset.
> May 17 16:19:36 node01 kernel: sym2: <895> rev 0x1 on pci bus 2 devic=
e 1
> function 0 irq 10
> May 17 16:19:36 node01 kernel: sym2: Symbios NVRAM, ID 7, Fast-40, LV=
D,
> parity checking
> May 17 16:19:36 node01 kernel: sym2: open drain IRQ line driver, usin=
g
> on-chip SRAM
> May 17 16:19:36 node01 kernel: sym2: using LOAD/STORE-based firmware.
> May 17 16:19:36 node01 kernel: sym2: SCSI BUS has been reset.
> May 17 16:19:36 node01 kernel: scsi0 : sym-2.1.17a
> May 17 16:19:36 node01 kernel: scsi1 : sym-2.1.17a
> May 17 16:19:36 node01 kernel: scsi2 : sym-2.1.17a
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX
> 8680T1  Rev: 1339
> May 17 16:19:36 node01 kernel:   Type:
> Direct-Access                      ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel: sym0:0:0: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:1: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:2: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:3: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:4: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:5: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:6: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel: sym0:0:7: tagged command queuing enabl=
ed,
> command queue depth 16.
> May 17 16:19:36 node01 kernel:   Vendor: NEC       Model: CD-ROM
> DRIVE:466  Rev: 1.17
> May 17 16:19:36 node01 kernel:   Type:
> CD-ROM                             ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel:   Vendor: SIEMENS   Model: STM/L
> S1          Rev: 4.1b
> May 17 16:19:36 node01 kernel:   Type:
> Processor                          ANSI SCSI revision: 02
> May 17 16:19:36 node01 kernel: Attached scsi disk sda at scsi0, chann=
el
> 0, id 0, lun 0
> May 17 16:19:36 node01 kernel: Attached scsi disk sdb at scsi0, chann=
el
> 0, id 0, lun 1
> May 17 16:19:36 node01 kernel: Attached scsi disk sdc at scsi0, chann=
el
> 0, id 0, lun 2
> May 17 16:19:36 node01 kernel: Attached scsi disk sdd at scsi0, chann=
el
> 0, id 0, lun 3
> May 17 16:19:36 node01 kernel: Attached scsi disk sde at scsi0, chann=
el
> 0, id 0, lun 4
> May 17 16:19:36 node01 kernel: Attached scsi disk sdf at scsi0, chann=
el
> 0, id 0, lun 5
> May 17 16:19:36 node01 kernel: Attached scsi disk sdg at scsi0, chann=
el
> 0, id 0, lun 6
> May 17 16:19:36 node01 kernel: Attached scsi disk sdh at scsi0, chann=
el
> 0, id 0, lun 7
> May 17 16:19:36 node01 kernel: Attached scsi CD-ROM sr0 at scsi2,
> channel 0, id 5, lun 0
> May 17 16:19:36 node01 kernel: sym2:5: FAST-20 SCSI 20.0 MB/s ST (50.=
0
> ns, offset 16)
> May 17 16:19:36 node01 kernel: sr0: scsi3-mmc drive: 17x/40x cd/rw
> xa/form2 cdda tray
> May 17 16:19:36 node01 kernel: Uniform CD-ROM driver Revision: 3.12
> May 17 16:19:36 node01 kernel: sym0:0: FAST-20 SCSI 20.0 MB/s ST (50.=
0
> ns, offset 16)
> May 17 16:19:36 node01 kernel: SCSI device sda: 17776640 512-byte hdw=
r
> sectors (9102 MB)
> May 17 16:19:36 node01 kernel: Partition check:
> May 17 16:19:36 node01 kernel:  sda: sda1 sda2 sda3 sda4
> May 17 16:19:36 node01 kernel: SCSI device sdb: 17776640 512-byte hdw=
r
> sectors (9102 MB)
> May 17 16:19:36 node01 kernel:  sdb: sdb1
>=20
> Like you can see, it founds 8 disks !
> I tried to increase max_scsi_luns to 64 to see if it will find as man=
y
> disks as luns, but it does not go after lun7 =3D=3D> 8 disks
>=20
> There are 3 drivers in linux kernel 2.4.18 that supports may SCSI HBA
> (sym53c8xx,sym53c8xx_2 and ncr53c8xx) but I have always the same
> results...
>=20
> Infortunately, I can't make tests with other cards, because I don't h=
ave
> them !
> (scsi hvd connectors).
>=20
> Well, I don't know why the lk founds as many disks...
>=20
> What do you think about it ?
> Do you have any idea ?
>=20
> Thanks in advance for your help !

G=E9rard and Doug, thanks for your help.

But, in fact, after re-reading my email, I've seen it's confusing
because I didn't explain correctly the problem.

The lk 2.2 has the good comportment : it only finds the 2 disks.
And, that's ok, I have really only 2 disks to be seen.

The problem is with the 2.4 kernel that finds 8 disks but it should onl=
y
see 2 disks, because there is only 2 disks !

The other disks are not accessible :
$fdisk /dev/sdc

Unable to open /dev/sdc

It's the same from sdc to sdh...


I've tried in the 2.4 kernel to increase the max_scsi_luns because I
thought lk may find as disks as many luns I have, but it's not the case
: it don't find more than 8 disks (maybe this is reassuring...).

So here is the problem : the lk 2.4 finds more disks than I have !


Sorry about the confusing...

Thanks in advance for your help !

-------------
=46abien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
