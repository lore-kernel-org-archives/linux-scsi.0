Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5375735A3A9;
	Sat, 11 Jul 2026 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783783307; cv=none; b=kmUNw8ih9tnYHNcq3BZUgX4Qu6KH7WY3iZ8NSTuritJugRHVdDlKXXOHTtFh6DI9lMrUVt61AHjLfjQJi/mUVXIjt9NEakcTzfkaeSWGEmLGuww3p3K2YADpz8bA2Yx+RUnE+6eZ0vu7tdZgSqEVWlfRmr2ZFvopHBlURDKjuiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783783307; c=relaxed/simple;
	bh=dA+p/e0yU5GmI2+843t83Ws3vAPk7ZHcyx+dI89Sz1U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L72dgViX57b74k8mX764I6qDGvTgFvTMKPaXq3uzrlj9wwhBH2NvhRRrTHJSh4cMS7011bMxHD86tcCyasEPzt97zhGH4GFsmsOoLM2sP+O53+xqVz39o89EuKd3YEfaI06hZRXGQTCNMT+U9T5JYyl8vN+8Ngdrcl9jU+BySBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=ksoqK/zj; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Y9yDTbzU; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="ksoqK/zj";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Y9yDTbzU"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gyC9208hBzMlFY;
	Sat, 11 Jul 2026 17:21:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783783302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zGD2166erzzmBrOUSjlgc7V6NcBK4nb2itQnBTjxms=;
	b=ksoqK/zj+BidOqeAJJ7EKT02ziVUZdAZpUvhJMwQtSmRWjSq9Enio2FtjUZVXyDQeKcPS9
	tz3EEt5kqcm2UE7WJdYDM3b+KpBAVSFgo0g3D5mBCTAgfgfn5uP25Y5c2Om8YP0zHfM12z
	cTtb5RUpNqORLbagExvL5rRh5ClAY9dGm+PNTYbSKo32vko5Z12zm2a9Smho1qpekhzHJP
	uzV29wf7UQtMAkvXzHuC0UQ1Fhw09TFGSpBly6QMQVskI/ENe8Tf4ouU54ZEFFTBXOU5Wb
	dU/uMxvi3O5dII+fFRTJDMNJ6tw022Ppk5aZ0NZNabs/Rxu2ksDW/Y48+ev3Ew==
From: Maurice Hieronymus <mhi@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783783300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zGD2166erzzmBrOUSjlgc7V6NcBK4nb2itQnBTjxms=;
	b=Y9yDTbzUH5iQ+rWrMO26z0OIS3g+EqRjCkPCiekugHNCtM7hSviYHk68Cm/Xegt23h7q78
	WyQla1TBoqMmPXMPzpLAKJF1spAjJXMQ7ucmmcjPMC+tglQFyfu8TAEBTLKANlbEyyZNse
	xVN5Xf0BaS7yqkcpaFBbqTghqEybETOdS+VFYqsaZNrGvG06kQVhEK0pyytE3pStJkBp3r
	yYH8zCv/wVf3PmL5YByhmUTOpaKMZGZYEBodK+ddHvtw+rHGcLgXRyfBX/cMV4ZB3CE9Nl
	oVA1frLCK+jSksHMfitUChWECby6KcNDEFsVc/6uJaCeoPpBH16kWBQ82HjtTA==
Date: Sat, 11 Jul 2026 17:21:07 +0200
Subject: [PATCH 2/2] PCI: Replace pci_dev->broken_parity_status with
 accessors
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-pci-dev-flags-v1-2-2fcf2811138c@mailbox.org>
References: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
In-Reply-To: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
To: Edward Cree <ecree.xilinx@gmail.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Bjorn Helgaas <bhelgaas@google.com>, Justin Tee <justin.tee@broadcom.com>, 
 Paul Ely <paul.ely@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
 netdev@vger.kernel.org, linux-net-drivers@amd.com, 
 linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
 linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 linux-edac@vger.kernel.org, Maurice Hieronymus <mhi@mailbox.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783783272; l=3918;
 i=mhi@mailbox.org; s=20260525; h=from:subject:message-id;
 bh=dA+p/e0yU5GmI2+843t83Ws3vAPk7ZHcyx+dI89Sz1U=;
 b=2KUtaRPN52gN+DrVoSi0Gx1KvBexgp3rJLmXihe43P4Nxd7ql/LG0mNOPKmJYGQTEluKIkZ/a
 e0xF1urLLB7BZdfXCqB9rBoVHA+cFHOIyMacXK65ieb1QbtT7PbaILy
X-Developer-Key: i=mhi@mailbox.org; a=ed25519;
 pk=AHlEkGG3hpXZHntlEzF42Ip/LFyXWOgsNUvaHqAnV80=
X-MBO-RS-ID: c995304cfe7236ecf3e
X-MBO-RS-META: kw8gscg45gpin8zawfowe9q3as1dmn7e

`broken_parity_status` shares a C bitfield word in `struct pci_dev`
with many other bits. `broken_parity_status_store()` writes it from
sysfs at any time without taking any lock, so userspace can make it
race with every other writer of the same word, e.g. `pci_set_master()`
from a runtime PM resume path, and updates of neighboring bits can be
lost.

Move the bit into the `flags` bitmap modified with atomic bitops,
using the accessor pattern introduced by the previous commit.

Signed-off-by: Maurice Hieronymus <mhi@mailbox.org>
---
 drivers/edac/edac_pci_sysfs.c | 4 ++--
 drivers/pci/pci-sysfs.c       | 4 ++--
 include/linux/pci.h           | 5 ++++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 9f437f648e4e..fadc61235f1f 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -554,7 +554,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 	/* check the status reg for errors on boards NOT marked as broken
 	 * if broken, we cannot trust any of the status bits
 	 */
-	if (status && !dev->broken_parity_status) {
+	if (status && !pci_dev_broken_parity_status(dev)) {
 		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
 				"Signaled System Error on %s\n",
@@ -593,7 +593,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 		/* check the secondary status reg for errors,
 		 * on NOT broken boards
 		 */
-		if (status && !dev->broken_parity_status) {
+		if (status && !pci_dev_broken_parity_status(dev)) {
 			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
 					"Signaled System Error on %s\n",
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5ec0b245a69b..5e094d1e23e3 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -80,7 +80,7 @@ static ssize_t broken_parity_status_show(struct device *dev,
 					 char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	return sysfs_emit(buf, "%u\n", pdev->broken_parity_status);
+	return sysfs_emit(buf, "%u\n", pci_dev_broken_parity_status(pdev));
 }
 
 static ssize_t broken_parity_status_store(struct device *dev,
@@ -93,7 +93,7 @@ static ssize_t broken_parity_status_store(struct device *dev,
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	pdev->broken_parity_status = !!val;
+	pci_dev_assign_broken_parity_status(pdev, val);
 
 	return count;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9964646bdd46..fdcd9b1b7371 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -347,10 +347,13 @@ struct rcec_ea;
  *		bookkeeping state, maintained by pci_set_master(),
  *		pci_clear_master() and pci_disable_device(); modifying it
  *		does not itself change the hardware state.
+ * @PCI_DEV_FLAG_BROKEN_PARITY_STATUS: Device generates false positive
+ *		parity errors; set via sysfs.
  * @PCI_DEV_FLAG_COUNT: Number of defined struct_pci_dev_flags.
  */
 enum struct_pci_dev_flags {
 	PCI_DEV_FLAG_BUSMASTER = 0,
+	PCI_DEV_FLAG_BROKEN_PARITY_STATUS = 1,
 
 	PCI_DEV_FLAG_COUNT
 };
@@ -482,7 +485,6 @@ struct pci_dev {
 
 	unsigned int	no_msi:1;		/* May not use MSI */
 	unsigned int	block_cfg_access:1;	/* Config space access blocked */
-	unsigned int	broken_parity_status:1;	/* Generates false positive parity */
 	unsigned int	irq_reroute_variant:2;	/* Needs IRQ rerouting variant */
 	unsigned int	msi_enabled:1;
 	unsigned int	msix_enabled:1;
@@ -626,6 +628,7 @@ static inline void pci_dev_assign_##accessor_name(struct pci_dev *pdev, bool val
 }
 
 __create_pci_dev_flag_accessors(busmaster, PCI_DEV_FLAG_BUSMASTER);
+__create_pci_dev_flag_accessors(broken_parity_status, PCI_DEV_FLAG_BROKEN_PARITY_STATUS);
 
 #undef __create_pci_dev_flag_accessors
 

-- 
2.51.2

