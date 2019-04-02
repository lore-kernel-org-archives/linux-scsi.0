From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: correcting incorrect peripheral device type 0x0
Date: Tue, 2 Apr 2019 17:05:05 +0200
Message-ID: <ab8d589f-db76-9a95-1b55-3e906ad89487@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Petersen <martin.petersen@oracle.com>, Avri Altman <avri.altman@wdc.com>, Alim Akhtar <alim.akhtar@samsung.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

In my boot log, when UFS is enabled, I get the following warnings:

scsi 0:0:0:49488: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c150hN
scsi 0:0:0:49488: Well-known LUN    SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
scsi 0:0:0:49476: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c144hN
scsi 0:0:0:49476: Well-known LUN    SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
scsi 0:0:0:49456: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c130hN
scsi 0:0:0:49456: Well-known LUN    SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6

Is there something I can/should do to fix these issues?
Or may they be safely ignored?

Regards.
