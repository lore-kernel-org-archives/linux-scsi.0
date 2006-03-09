From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/10] qla2xxx: Firmware updates.
Date: Thu, 9 Mar 2006 14:32:04 -0800
Message-ID: <20060309223204.GG10181@andrew-vasquezs-powerbook-g4-15.local>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:15191 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1752005AbWCIWcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:32:04 -0500
Content-Disposition: inline
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Resync with latest 23xx firmware -- 3.03.20.
Resync with latest 24xx firmware -- 4.00.18.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 Retrieve from:
 ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.04k/2010-qla2xxx-Firmware-updates.txt

 drivers/scsi/qla2xxx/ql2300_fw.c |14624 +++++++++++++--------------
 drivers/scsi/qla2xxx/ql2322_fw.c |14135 +++++++++++++-------------
 drivers/scsi/qla2xxx/ql2400_fw.c |20826 +++++++++++++++++++-------------------
 3 files changed, 24866 insertions(+), 24719 deletions(-)
