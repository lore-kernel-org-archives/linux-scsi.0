From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] scsi/ahci.c: remove an unused function
Date: Fri, 29 Oct 2004 01:16:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041028231613.GF3207@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263083AbUJ1XW0@vger.kernel.org>
Content-Disposition: inline
To: jgarzik@pobox.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The patch below removes an unused function from drivers/scsi/ahci.c


diffstat output:
 drivers/scsi/ahci.c |    9 ---------
 1 files changed, 9 deletions(-)


Signed-off-by: Adrian Bunk <bunk@stusta.de>

- --- linux-2.6.10-rc1-mm1-full/drivers/scsi/ahci.c.old	2004-10-28 23:28:09.000000000 +0200
+++ linux-2.6.10-rc1-mm1-full/drivers/scsi/ahci.c	2004-10-28 23:28:17.000000000 +0200
@@ -504,15 +504,6 @@
 	ahci_fill_sg(qc);
 }
 
- -static inline void ahci_dma_complete (struct ata_port *ap,
- -                                     struct ata_queued_cmd *qc,
- -				     int have_err)
- -{
- -	/* get drive status; clear intr; complete txn */
- -	ata_qc_complete(ata_qc_from_tag(ap, ap->active_tag),
- -			have_err ? ATA_ERR : 0);
- -}
- -
 static void ahci_intr_error(struct ata_port *ap, u32 irq_stat)
 {
 	void *mmio = ap->host_set->mmio_base;

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFBgX29mfzqmE8StAARAgGOAJ4n5TTw8dyMqfXbwGgY1yZnoaHtdwCfWpHq
O6Innq1eA5acFXUHQJ5syng=
=GUWn
-----END PGP SIGNATURE-----
