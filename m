From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/15] qla2xxx: Remove obsolete firmware-loader-module support.
Date: Wed, 17 May 2006 15:09:34 -0700
Message-ID: <11479037694085-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:47290 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751224AbWEQWJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:35 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 Retrieve from:
 ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.05k/0010-qla2xxx-Remove-obsolete-firmware-loader-module-support.txt

6ae9404142e68a379d30bd7c48d1b8b4c9cdb272
 drivers/scsi/qla2xxx/Kconfig     |   45 
 drivers/scsi/qla2xxx/Makefile    |   14 
 drivers/scsi/qla2xxx/ql2100.c    |   91 
 drivers/scsi/qla2xxx/ql2100_fw.c | 4848 ---------------
 drivers/scsi/qla2xxx/ql2200.c    |   91 
 drivers/scsi/qla2xxx/ql2200_fw.c | 5333 ----------------
 drivers/scsi/qla2xxx/ql2300.c    |  114 
 drivers/scsi/qla2xxx/ql2300_fw.c | 7746 ------------------------
 drivers/scsi/qla2xxx/ql2322.c    |  119 
 drivers/scsi/qla2xxx/ql2322_fw.c | 8376 --------------------------
 drivers/scsi/qla2xxx/ql2400.c    |  138 
 drivers/scsi/qla2xxx/ql2400_fw.c |12346 --------------------------------------
 drivers/scsi/qla2xxx/qla_def.h   |   25 
 drivers/scsi/qla2xxx/qla_fw.h    |    1 
 drivers/scsi/qla2xxx/qla_gbl.h   |    3 
 drivers/scsi/qla2xxx/qla_init.c  |  134 
 drivers/scsi/qla2xxx/qla_os.c    |   54 
 17 files changed, 22 insertions(+), 39456 deletions(-)
 delete mode 100644 drivers/scsi/qla2xxx/ql2100.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2100_fw.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2200.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2200_fw.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2300.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2300_fw.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2322.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2322_fw.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2400.c
 delete mode 100644 drivers/scsi/qla2xxx/ql2400_fw.c

