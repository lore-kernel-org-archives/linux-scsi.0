From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/10] qla2xxx: Remove legacy ISP6312 firmware loader.
Date: Thu, 9 Mar 2006 14:31:47 -0800
Message-ID: <20060309223147.GF10181@andrew-vasquezs-powerbook-g4-15.local>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:24918 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751968AbWCIWbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:31:48 -0500
Content-Disposition: inline
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 Retrieve from:
 ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.04k/2009-qla2xxx-Remove-legacy-ISP6312-firmware-loader.txt

 drivers/scsi/qla2xxx/ql6312.c    |  101 -
 drivers/scsi/qla2xxx/ql6312_fw.c | 7078 --------------------------------------
 2 files changed, 0 insertions(+), 7179 deletions(-)
 delete mode 100644 drivers/scsi/qla2xxx/ql6312.c
 delete mode 100644 drivers/scsi/qla2xxx/ql6312_fw.c
