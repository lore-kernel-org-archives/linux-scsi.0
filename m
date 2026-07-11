Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF92DC764;
	Sat, 11 Jul 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783783298; cv=none; b=FOVGyqLbdjPHf851VxQLoDHq81OuyHvGMvAhdOlVvBjxR5A3poYc6yuEIM97AOIr7aClmhcijNlRUkGqC0O+ESCh3R46RlRlKkG9PaLTnZrZb6WGf+iwOJG2NryJpR46h+nLyTRMjG+s1k0pviFGERzAIxSeOUSRLfDZJ0NbnQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783783298; c=relaxed/simple;
	bh=UvTBMgm38RY8zEXs2NATRQuun95jyORW9mMSNxmV5FA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fb+I7RJFnyLLdS0kz+RMY1Y3xl1mRQEJgAfcDLn6kCJcv5hy1R4rzNgS/Drl80BZ2iDmJVb8Z8ShF7LY7ZwAT4dNF9n0Lhj0BNqbeIgL1KIDWaxQmtEm33h9CWfDDlD91kBCeoVW6DZovvUH1iZHTQ6Cm/vzsBWLR2Y0fm6BU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=vNC6Nr8Q; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=adq2ry/u; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="vNC6Nr8Q";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="adq2ry/u"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4gyC8s58czzMlFw;
	Sat, 11 Jul 2026 17:21:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783783293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/l7Xlwgc32SRo4MSsc6Qw/JiVZgPEEXCYL8AXhdB7g=;
	b=vNC6Nr8Qu+GAEZlEV//+bczXk5JjcPJWznDQiXnBFy48QVgQnoKKU6G0BwyiTsYd/cPzSl
	N2fsc9kmUUDjl/F7JMWNChYNPd4h5ors5BL8n/kDs55QGNLeWi60GgMVxZ/6+DxBfn1KHH
	Nx+FJq10I7wAfD/bMZtaoOh3BRX4DQLdw04vhMvksj+2ZAsK08ACiXzlu0H0FXVrPufl9o
	MeAuDi6b2W2KdZsjNaeYhaIsJ/jq+thJaE5aUXQXpl1JhtAI1MeKVnSYZH390u27CdSlot
	J+on4CbeW+nJOgukoXg8+k8/kAJu1gluMBR7muSIAkpAmsPpyiuEpaeqTs0cgw==
From: Maurice Hieronymus <mhi@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783783291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/l7Xlwgc32SRo4MSsc6Qw/JiVZgPEEXCYL8AXhdB7g=;
	b=adq2ry/uVyggAKv2tF+LozCCQKi72ZDJ5hkkep0oXTPNmMLzUhP2jR2qG1EoapxFVvxXAo
	Pn4WlzKfzjyGrEzeCbit25hbfaoOumavShFYHsb7YpfugGHtxo6IaohAuw5EuEPvoI/fWk
	+El95ldUl99KQu8xxoOMq2VGA/oNSgfncQ5f8/1LGzdO+oGTr9Eh/jgBukgFifgxOmK63v
	nzXEOCH2MmsrNekjdoef+T9BwPg1lQe4fyVzSCHLwIjQaKvhTYNvEYMZhK01GxfKVKiy3E
	9R1HoWfC+Mj3jMe7irk53eANjShhgTjnn/VRyReCnFnEQdYUhYEKkBDp9oLZUg==
Date: Sat, 11 Jul 2026 17:21:06 +0200
Subject: [PATCH 1/2] PCI: Replace pci_dev->is_busmaster with accessors
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-pci-dev-flags-v1-1-2fcf2811138c@mailbox.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783783272; l=8697;
 i=mhi@mailbox.org; s=20260525; h=from:subject:message-id;
 bh=UvTBMgm38RY8zEXs2NATRQuun95jyORW9mMSNxmV5FA=;
 b=pQSZj8wz+D4fY0P5+pOyu6Es4y8tnTZt88mjrg56g8MYWNwlgOVIFy3c+5QCEWgww49IBV8hS
 52acPwOKzvHB3t4voqsaavWiw/3UmrRwsmlYpGKuMcaEd6RHjAKdJJ5
X-Developer-Key: i=mhi@mailbox.org; a=ed25519;
 pk=AHlEkGG3hpXZHntlEzF42Ip/LFyXWOgsNUvaHqAnV80=
X-MBO-RS-META: er15gbymiuy8xweyxi8sy8tna1xynnrb
X-MBO-RS-ID: 4dfa2ffa0a7b52f860d

`is_busmaster` is one bit of a ~60-bit C bitfield in `struct pci_dev`.
Bits sharing a bitfield word must not be modified concurrently, but its
writers take no common lock: `pci_set_master()` can run without the
device lock (e.g. from runtime PM resume paths), `pci_disable_device()`
clears the bit, and other bits in the same word are written from
entirely different contexts, e.g. `broken_parity_status` from sysfs.
Concurrent read-modify-write cycles of the shared word can then lose
updates.

Move `is_busmaster` into a new `flags` bitmap modified with atomic
bitops and accessed through generated accessor functions, following the
example of commit a7cc262a1135 ("driver core: Replace dev->offline +
->offline_disabled with accessors"). More bitfield flags can follow the
same pattern later.

This also unblocks the Rust device enabling API rework [1], where a
guard object calls `pci_disable_device()` from contexts that may run
concurrently with `pci_set_master()`.

Link: https://lore.kernel.org/rust-for-linux/DJOEYVBS17MJ.1YD3TNGQBWHNK@kernel.org/ [1]
Suggested-by: Danilo Krummrich <dakr@kernel.org>
Cc: rust-for-linux@vger.kernel.org
Signed-off-by: Maurice Hieronymus <mhi@mailbox.org>
---
 drivers/net/ethernet/sfc/falcon/farch.c     |  2 +-
 drivers/net/ethernet/sfc/siena/farch.c      |  2 +-
 drivers/pci/pci-driver.c                    |  2 +-
 drivers/pci/pci.c                           |  6 ++---
 drivers/scsi/lpfc/lpfc_init.c               |  4 ++--
 drivers/xen/xen-pciback/conf_space_header.c |  4 ++--
 drivers/xen/xen-pciback/pciback_ops.c       |  4 ++--
 include/linux/pci.h                         | 37 ++++++++++++++++++++++++++++-
 8 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/farch.c b/drivers/net/ethernet/sfc/falcon/farch.c
index 23d507a3820d..42594bd7e818 100644
--- a/drivers/net/ethernet/sfc/falcon/farch.c
+++ b/drivers/net/ethernet/sfc/falcon/farch.c
@@ -724,7 +724,7 @@ int ef4_farch_fini_dmaq(struct ef4_nic *efx)
 	/* Do not attempt to write to the NIC during EEH recovery */
 	if (efx->state != STATE_RECOVERY) {
 		/* Only perform flush if DMA is enabled */
-		if (efx->pci_dev->is_busmaster) {
+		if (pci_dev_busmaster(efx->pci_dev)) {
 			efx->type->prepare_flush(efx);
 			rc = ef4_farch_do_flush(efx);
 			efx->type->finish_flush(efx);
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 7613d7988894..f673af4c77b6 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -723,7 +723,7 @@ int efx_farch_fini_dmaq(struct efx_nic *efx)
 	/* Do not attempt to write to the NIC during EEH recovery */
 	if (efx->state != STATE_RECOVERY) {
 		/* Only perform flush if DMA is enabled */
-		if (efx->pci_dev->is_busmaster) {
+		if (pci_dev_busmaster(efx->pci_dev)) {
 			efx->type->prepare_flush(efx);
 			rc = efx_farch_do_flush(efx);
 			efx->type->finish_flush(efx);
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1..412afa12a285 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -649,7 +649,7 @@ static int pci_pm_reenable_device(struct pci_dev *pci_dev)
 	 * if the device was busmaster before the suspend, make it busmaster
 	 * again
 	 */
-	if (pci_dev->is_busmaster)
+	if (pci_dev_busmaster(pci_dev))
 		pci_set_master(pci_dev);
 
 	return retval;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 77b17b13ee61..c4fd6fe6098d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2045,7 +2045,7 @@ static void pci_enable_bridge(struct pci_dev *dev)
 		pci_enable_bridge(bridge);
 
 	if (pci_is_enabled(dev)) {
-		if (!dev->is_busmaster)
+		if (!pci_dev_busmaster(dev))
 			pci_set_master(dev);
 		return;
 	}
@@ -2205,7 +2205,7 @@ void pci_disable_device(struct pci_dev *dev)
 
 	do_pci_disable_device(dev);
 
-	dev->is_busmaster = 0;
+	pci_dev_assign_busmaster(dev, false);
 }
 EXPORT_SYMBOL(pci_disable_device);
 
@@ -4120,7 +4120,7 @@ static void __pci_set_master(struct pci_dev *dev, bool enable)
 			enable ? "enabling" : "disabling");
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
-	dev->is_busmaster = enable;
+	pci_dev_assign_busmaster(dev, enable);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 82af59c913e9..08dc06e7dfc2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14398,7 +14398,7 @@ lpfc_io_slot_reset_s3(struct pci_dev *pdev)
 
 	pci_restore_state(pdev);
 
-	if (pdev->is_busmaster)
+	if (pci_dev_busmaster(pdev))
 		pci_set_master(pdev);
 
 	spin_lock_irq(&phba->hbalock);
@@ -15251,7 +15251,7 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	 */
 	pci_save_state(pdev);
 
-	if (pdev->is_busmaster)
+	if (pci_dev_busmaster(pdev))
 		pci_set_master(pdev);
 
 	spin_lock_irq(&phba->hbalock);
diff --git a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
index 8b50cbcbdfe1..59a89f915916 100644
--- a/drivers/xen/xen-pciback/conf_space_header.c
+++ b/drivers/xen/xen-pciback/conf_space_header.c
@@ -81,10 +81,10 @@ static int command_write(struct pci_dev *dev, int offset, u16 value, void *data)
 			dev_data->enable_intx = 0;
 	}
 
-	if (!dev->is_busmaster && is_master_cmd(value)) {
+	if (!pci_dev_busmaster(dev) && is_master_cmd(value)) {
 		dev_dbg(&dev->dev, "set bus master\n");
 		pci_set_master(dev);
-	} else if (dev->is_busmaster && !is_master_cmd(value)) {
+	} else if (pci_dev_busmaster(dev) && !is_master_cmd(value)) {
 		dev_dbg(&dev->dev, "clear bus master\n");
 		pci_clear_master(dev);
 	}
diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index bfc186bf05bc..01f4705421c9 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -125,14 +125,14 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
 		if (pci_is_enabled(dev))
 			pci_disable_device(dev);
 
-		dev->is_busmaster = 0;
+		pci_dev_assign_busmaster(dev, false);
 	} else {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
 		if (cmd & (PCI_COMMAND_INVALIDATE)) {
 			cmd &= ~(PCI_COMMAND_INVALIDATE);
 			pci_write_config_word(dev, PCI_COMMAND, cmd);
 
-			dev->is_busmaster = 0;
+			pci_dev_assign_busmaster(dev, false);
 		}
 	}
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ebb5b9d76360..9964646bdd46 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -336,6 +336,25 @@ struct pci_sriov;
 struct pci_p2pdma;
 struct rcec_ea;
 
+/**
+ * enum struct_pci_dev_flags - Flags in struct pci_dev
+ *
+ * Each flag has a set of accessor functions created via
+ * __create_pci_dev_flag_accessors() and must only be accessed through
+ * them.
+ *
+ * @PCI_DEV_FLAG_BUSMASTER: Bus mastering is enabled on the device. Pure
+ *		bookkeeping state, maintained by pci_set_master(),
+ *		pci_clear_master() and pci_disable_device(); modifying it
+ *		does not itself change the hardware state.
+ * @PCI_DEV_FLAG_COUNT: Number of defined struct_pci_dev_flags.
+ */
+enum struct_pci_dev_flags {
+	PCI_DEV_FLAG_BUSMASTER = 0,
+
+	PCI_DEV_FLAG_COUNT
+};
+
 /* struct pci_dev - describes a PCI device
  *
  * @supported_speeds:	PCIe Supported Link Speeds Vector (+ reserved 0 at
@@ -461,7 +480,6 @@ struct pci_dev {
 	unsigned int	pref_64_window:1;	/* Pref mem window is 64-bit */
 	unsigned int	multifunction:1;	/* Multi-function device */
 
-	unsigned int	is_busmaster:1;		/* Is busmaster */
 	unsigned int	no_msi:1;		/* May not use MSI */
 	unsigned int	block_cfg_access:1;	/* Config space access blocked */
 	unsigned int	broken_parity_status:1;	/* Generates false positive parity */
@@ -592,8 +610,25 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+
+	/* PCI_DEV_FLAG_XXX flags. Use atomic bitfield operations to modify. */
+	DECLARE_BITMAP(flags, PCI_DEV_FLAG_COUNT);
 };
 
+#define __create_pci_dev_flag_accessors(accessor_name, flag_name) \
+static inline bool pci_dev_##accessor_name(const struct pci_dev *pdev) \
+{ \
+	return test_bit(flag_name, pdev->flags); \
+} \
+static inline void pci_dev_assign_##accessor_name(struct pci_dev *pdev, bool value) \
+{ \
+	assign_bit(flag_name, pdev->flags, value); \
+}
+
+__create_pci_dev_flag_accessors(busmaster, PCI_DEV_FLAG_BUSMASTER);
+
+#undef __create_pci_dev_flag_accessors
+
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_IOV

-- 
2.51.2

