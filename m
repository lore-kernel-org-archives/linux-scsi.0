From: Pavel@Janik.cz (Pavel =?iso-8859-2?q?Jan=EDk?=)
Subject: qlogic QLA2200F/66 with Compaq HSG80?
Date: Mon, 09 Sep 2002 11:29:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3it1fzf1o.fsf@Janik.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

this is a copy of an e-mail I sent to lkml last week. Can you please he=
lp
he with this issue? Please keep me in CC: I'm not subscribed here.

we have Compaq Proliant DL380 with two FC cards Qlogic ISP2200A in 64bi=
t
PCI bus.

The system has two CPUS:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 6
cpu MHz		: 996.893
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
sep_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 mmx fxsr xmm
bogomips	: 1992.29

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 6
cpu MHz		: 996.893
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
sep_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 mmx fxsr xmm
bogomips	: 1985.74

We have it running with 2.2.19 with qla driver version 4.46.12b. All
devices on FC switch are visible (on both cards):

Attached devices:=20
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: DEC      Model: HSG80CCL         Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 01
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 02
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 03
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 04
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 05
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 06
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 00 Lun: 07
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: DEC      Model: TL800    (C) DEC Rev: 0409
  Type:   Medium Changer                   ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 01
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2150
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 02
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2150
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 03
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2150
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 04
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2561
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: DEC      Model: HSG80CCL         Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 01
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 02
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 03
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 04
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 05
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 06
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 07
  Vendor: DEC      Model: HSG80            Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02

We would like to upgrade the system to 2.4.19 with the latest qlogic's
driver 6.1b5. We have succeeded, but HSG80s are no more visible...:

Attached devices:=20
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: DEC      Model: HSG80CCL         Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: DEC      Model: TL800    (C) DEC Rev: 0409
  Type:   Medium Changer                   ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 01
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2150
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 02
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2150
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 03
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2150
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 04
  Vendor: DEC      Model: TZ89     (C) DEC Rev: 2561
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: DEC      Model: HSG80CCL         Rev: V86F
  Type:   Unknown                          ANSI SCSI revision: 02

We have tried both SMP and NOSMP build, the result is the same (ie. all
device except HSG80s ae visible).

We have also tried to use kernel's qlogicfc:

Sep  7 01:37:37 intranet kernel: qlogicfc0 : Loop Reinitialized
Sep  7 01:37:37 intranet kernel: qlogicfc0 : Link is Up
Sep  7 01:37:37 intranet kernel: qlogicfc1 : Loop Reinitialized
Sep  7 01:37:37 intranet kernel: qlogicfc1 : Link is Up
Sep  7 01:37:37 intranet kernel: qlogicfc1 : Fabric found.
Sep  7 01:37:37 intranet kernel: qlogicfc1 : Port Database
Sep  7 01:37:37 intranet kernel: wwn: 210000e08b02b749  scsi_id: 0  loo=
p_id: 0
Sep  7 01:37:37 intranet kernel: wwn: 50001fe1000e8803  scsi_id: 1  loo=
p_id: 81
Sep  7 01:37:37 intranet kernel: scsi0 : QLogic ISP2200 SCSI on PCI bus=
 03 device 28 irq 15 base 0x3000
Sep  7 01:37:37 intranet kernel: scsi1 : QLogic ISP2200 SCSI on PCI bus=
 03 device 30 irq 5 base 0x3400
Sep  7 01:37:37 intranet kernel: qlogicfc0 : Fabric found.
Sep  7 01:37:37 intranet kernel: qlogicfc0 : Get All Next failed 4005.
Sep  7 01:37:37 intranet kernel: qlogicfc0 : Port Database
Sep  7 01:37:37 intranet kernel: wwn: 210000e08b033967  scsi_id: 0  loo=
p_id: 0
Sep  7 01:37:38 intranet kernel: wwn: 500508b3001025f1  scsi_id: 1  loo=
p_id: 81
Sep  7 01:37:41 intranet kernel: qlogicfc0 : Loop Reinitialized
Sep  7 01:37:42 intranet kernel: qlogicfc0 : Fabric found.
Sep  7 01:37:42 intranet kernel: qlogicfc0 : Port Database
Sep  7 01:37:42 intranet kernel: wwn: 210000e08b033967  scsi_id: 0  loo=
p_id: 0
Sep  7 01:37:42 intranet kernel: wwn: 500508b3001025f1  scsi_id: 1  loo=
p_id: 81
Sep  7 01:37:42 intranet kernel: wwn: 50001fe1000e8804  scsi_id: 2  loo=
p_id: 82
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: TL800    (C=
) DEC  Rev: 0409
Sep  7 01:37:42 intranet kernel:   Type:   Medium Changer              =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: TZ89     (C=
) DEC  Rev: 2150
Sep  7 01:37:42 intranet kernel:   Type:   Sequential-Access           =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: TZ89     (C=
) DEC  Rev: 2150
Sep  7 01:37:42 intranet kernel:   Type:   Sequential-Access           =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: TZ89     (C=
) DEC  Rev: 2150
Sep  7 01:37:42 intranet kernel:   Type:   Sequential-Access           =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: TZ89     (C=
) DEC  Rev: 2561
Sep  7 01:37:42 intranet kernel:   Type:   Sequential-Access           =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 12
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80CCL   =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Direct-Access               =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 12
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80CCL   =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Direct-Access               =
       ANSI SCSI revision: 02
Sep  7 01:37:42 intranet kernel: scsi: unknown type 31
Sep  7 01:37:42 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:42 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:43 intranet kernel: scsi: unknown type 31
Sep  7 01:37:43 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:43 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:43 intranet kernel: scsi: unknown type 31
Sep  7 01:37:43 intranet kernel:   Vendor: DEC       Model: HSG80      =
       Rev: V86F
Sep  7 01:37:43 intranet kernel:   Type:   Unknown                     =
       ANSI SCSI revision: 02
Sep  7 01:37:43 intranet kernel: Attached scsi disk sda at scsi0, chann=
el 0, id 2, lun 4
Sep  7 01:37:43 intranet kernel: Attached scsi disk sdb at scsi1, chann=
el 0, id 1, lun 4
Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type 1=
2
Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type 3=
1
Sep  7 01:37:43 intranet last message repeated 5 times
Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type 1=
2
Sep  7 01:37:43 intranet kernel: resize_dma_pool: unknown device type 3=
1
Sep  7 01:37:43 intranet last message repeated 5 times
Sep  7 01:37:43 intranet kernel: SCSI device sda: 71114623 512-byte hdw=
r sectors (36411 MB)
Sep  7 01:37:43 intranet kernel:  sda: sda1 sda3
Sep  7 01:37:43 intranet kernel: SCSI device sdb: 71114623 512-byte hdw=
r sectors (36411 MB)
Sep  7 01:37:43 intranet kernel:  sdb: sdb1 sdb3

So it to sees all devices, but there were problems when accessing
filesystems on the disks (ls -l in the directory from FC took about
a minute to finish and did not print correct informations). Kernel driv=
er
is unusable for us. Our goal is to see HSG80s with the latest qlogic dr=
iver
so we can create multipath failover configuration then.

There are some comments about Compaq HSG80 in the sources and makefile.=
 We
also tried to build the module with HSG80=3Dy, but the result is the sa=
me. We
have also tried to modify values of HSG* variables, but no difference..=
=2E

There is a tarball with all datas we collected at http://www.janik.cz/t=
mp/qlogic-compag-hsg80.tar.gz
We can provide any further details you want.

Is there anyone running that card with Compaq's HSG80? In multipath
failover configuration?
--=20
Pavel Jan=EDk

Buying an operating system without source is like buying a self-assembl=
y
Space Shuttle with no instructions.
                  -- Jeremy Allison in linux-kernel
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
