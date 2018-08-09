From: Janek Kotas <jank@cadence.com>
Subject: [PATCH v3 0/2] scsi: ufs: Add UFS platform driver and bindings for
 Cadence UFS
Date: Thu, 9 Aug 2018 13:24:44 +0000
Message-ID: <1EAD7741-4CEF-4E23-9A3F-918F07B52E35@global.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <600FC4CD23F98B49A639ADE73BC4D8A0@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "robh+dt@kernel.org" <robh+dt@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patchset adds a driver support for Cadence UFS controller.
It was verified on Cadence Palladium emulation platform.

Changes since V2:
	Updated dt bindings documentation.

Changes since V1:
	Renamed the documentation file name to cdns,ufshc.txt.
	Updated interrupt and register mapping.
	Added license information.
	Added a missing PHY clock.

Jan Kotas (2):
  dt-bindings: ufs: Add bindings for Cadence UFS
  scsi: ufs: Add UFS platform driver for Cadence UFS

 .../devicetree/bindings/ufs/cdns,ufshc.txt         |  31 +++++
 drivers/scsi/ufs/Kconfig                           |   8 ++
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/cdns-pltfrm.c                     | 147 +++++++++++++++++=
++++
 4 files changed, 187 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
 create mode 100644 drivers/scsi/ufs/cdns-pltfrm.c

--=20
2.15.0
