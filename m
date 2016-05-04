From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] eata_pio: missing break statement
Date: Wed, 4 May 2016 09:13:41 +0300
Message-ID: <20160504061341.GA22064@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This missing break statement bug predates git.  It's a very minor thing,
it means that we print a '?' instead of a 'z' in dmesg.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index ca8003f..4299fa4 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -729,6 +729,7 @@ static int register_pio_HBA(long base, struct get_conf *gc, struct pci_dev *pdev
 		break;
 	case 0x24:
 		SD(sh)->EATA_revision = 'z';
+		break;
 	default:
 		SD(sh)->EATA_revision = '?';
 	}
