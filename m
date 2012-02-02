From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 0/4] [SCSI] ufshcd: UFS Host Controller Driver
Date: Thu,  2 Feb 2012 10:27:25 +0530
Message-ID: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

=46rom: Santosh Yaraganavi <santoshsy@gmail.com>

UFS is designed to be the most advanced specification for
both embedded and removable flash memory-based storage in mobile device=
s
such as smart phones and tablet computers.  The UFS standard represents
an evolutionary progression of JEDEC standards in this field, and has b=
een
specifically tailored for mobile applications and computing systems req=
uiring
high performance and low power consumption.  The initial data throughpu=
t for
UFS will be ~300 megabytes per second (MB/s), and the standard also sup=
ports
command queuing features to raise random read/write speeds.

To achieve the highest performance and most power efficient data
transport, UFS uses the leading industry interface standards to form it=
s
Interconnect Layer: MIPI=C2=AE Alliance=E2=80=99s M-PHY and UniProSM  s=
pecifications.
UniPro is a comprehensive specification meant to act as a universal
chip-to-chip protocol, providing a common tunnel for other protocols.
The M-PHY interface is designed as the primary physical interface (PHY =
layer)
for the UniPro specification, and is a high speed serial interface targ=
eting
up to 2.9 gigabits per second (Gbps) per lane with up-scalability to 5.=
8Gbps
per lane.

MIPI=E2=80=99s M-PHY and UniPro specifications are optimized for mobile=
 applications,
and are designed from the ground up for efficient power management in m=
obile
devices, including enabling efficient transitions between the active an=
d power
save modes. Combined with a low active power level and a near-zero idle=
 power
level, UFS offers the promise for significant reductions in device powe=
r
consumption.

The UFS standard adopts the well-known SCSI Architecture Model and comm=
and
protocols supporting multiple commands with command queuing features an=
d
enabling a multi-thread programming paradigm. This differs from convent=
ional
flash-based memory cards and embedded flash solutions which process one
command at a time, limiting random read/write access performance.
In addition, a forthcoming complementary UFS Host Controller Interface =
(HCI)
specification will allow system designers greater flexibility by simpli=
fying
the involvement of the host processor in the operation of the flash sto=
rage
subsystem. The UFS HCI specification and the adoption of SCSI will prov=
ide
a well-known software programming model and enable wider market adoptio=
n.

This patchset contains PCIe based UFS host controller driver which comp=
lies
to UFSHCI 1.0 and 1.1. The driver is based on Linux SCSI framework.
The driver is tested with UFS Host controller(FPGA) and UFS device(FPGA=
).

This patch set is successfully applied on kernel version 3.3-rc2.

Santosh Yaraganavi (4):
  [SCSI] ufshcd: UFS Host controller driver
  [SCSI] ufshcd: UFS UTP Transfer requests handling
  [SCSI] ufshcd: UFSHCI error handling
  [SCSI] ufshcd: SCSI error handling

 drivers/scsi/Kconfig      |    1 +
 drivers/scsi/Makefile     |    1 +
 drivers/scsi/ufs/Kconfig  |   49 ++
 drivers/scsi/ufs/Makefile |    2 +
 drivers/scsi/ufs/ufs.h    |  203 +++++
 drivers/scsi/ufs/ufshcd.c | 1954 +++++++++++++++++++++++++++++++++++++=
++++++++
 drivers/scsi/ufs/ufshci.h |  360 +++++++++
 7 files changed, 2570 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/ufs/Kconfig
 create mode 100644 drivers/scsi/ufs/Makefile
 create mode 100644 drivers/scsi/ufs/ufs.h
 create mode 100644 drivers/scsi/ufs/ufshcd.c
 create mode 100644 drivers/scsi/ufs/ufshci.h

--=20
1.7.5.4
