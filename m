From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [KJ] [PATCH 07/19] drivers/scsi/atp870u: Use the DMA_{64,
	32}BIT_MASK constants
Date: Sun, 20 Feb 2005 18:01:37 +0100
Message-ID: <20050220170137.GH14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============52433070444343077=="
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============52433070444343077==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Description: Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11-rc4.orig/drivers/scsi/atp870u.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/atp870u.c	2005-02-16 21:29:57.000000000 +0100
@@ -2287,7 +2287,7 @@ static int atp870u_probe(struct pci_dev 
 	if (pci_enable_device(dev))
 		return -EIO;
 
-	if (pci_set_dma_mask(dev, 0xFFFFFFFFUL)) {
+	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
 		printk(KERN_ERR "atp870u: 32bit DMA mask required but not available.\n");
 		return -EIO;
 	}

--===============52433070444343077==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
http://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============52433070444343077==--
