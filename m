Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070244;
	b=z2uocDtHxzOU29o0+z9ZdQW/vCkpYVBLOkBa/4h4WkkB5sapAn+bj40K5cquuK2I3g0F
	 Owf96q5r+p+xFxOPIctA8CdrEAlbHt+lNM7jOCmSaGQnVI/aVNA1gezkyM74wrD3P1JI8
	 JIf6o0A+7T+iB1kb89T0g7wTsKmvbtfLKpTy+2P3Pne8H04llYXYtuqJP2tk+2hx2Sxby
	 ah3PKzQUIzfZqRWlLpDJmSLv+Cl4CzQVXsDEwkIuo3fKYA0OrMO4g2tq0gmP/utudCIYT
	 9Sq5LtVhCdItY3PGUV7/cc236H26CpUiMfRzLmfRqN73gVSsnra1ak+h/q1KIu1yYbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070244;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:Autocrypt:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=Zqs5FAKOeYN2zaQD7M4FEBwYgEUvFHUfNqEhW+NZ7BQ=;
	b=PXZEX4Gb0PQ9YjEY1cafpfgXRvslkuJ+wHv4NH/N1G8VaHjAvvTOQyJeDtsFWFHB23gj
	 ArB5WhmzY7iX5/83Tnzf6j/qWHs5UD+McthBjb4x7EWszp746txTJLT7FJXoOVsUlI/B+
	 JLNteisCYsk4RghJysN1hotl+g60SwTK24g9i6FSM91kXeCghj3YcIOJkpjgrDrdGGFPA
	 C86YsrRjrQIo5pzvSBsIh7AwnCy9YkrWwObjpBjfRAqhX8oJEThcx/ykyU5hw1TRFE008
	 66ZCDmktBbxjnT1HRa00qvdr8AVqaN2hpmrINghc8ToNklMT2XcIA8gdsHoN0HTzUSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b="QKF/1NpP";
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42324606A32E;
	Sat,  7 Nov 2026 16:50:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42324606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=QKF/1NpP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1794070242;
	bh=Brgliw6fuNNq1f0rA72STKHeddtLaFc23JkRVQl4DyE=;
	h=Message-ID:Subject:From:To:Date:From;
	b=QKF/1NpPZtRbuhOlv4UX1W363sR4EYtSwIPiTbF4vVk/xunU2UUpoadJvonsEeTo4
	 SHfNmAE8fDL3I624ETbef9eCNfYLVKHvn8/mdGqnIHtthpuHLoUipKz7N8UArnwSuo
	 EjsDn/JpS4te9+Bs5Vbm3Q6Oc4wI864ONSWjZ0fc=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 1AC7B1C01BA;
	Sat, 07 Nov 2026 11:50:42 -0500 (EST)
Message-ID: <49923933505639f8c35894464a0a8c57773d4877.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.4-rc1+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 07 Nov 2026 11:50:41 -0500
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4=
:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to ca14cc05808f9c0115c38bec53573bf93e030435:

  Merge branch '7.4/scsi-queue' into 7.4/scsi-fixes (2026-11-02 21:06:42 -0=
500)

----------------------------------------------------------------
Mostly fixes in drivers.  The three core changes are moving the target
reap into the main exit path of pseudo device allocation to fix a leak
and a couple of minor error propagation updates in bsg.  The largest
driver fix is the rethreading of Buslogic to enable context locking that
was held back from the merge window pull due to problems spotted by the
maintainer.

----------------------------------------------------------------
Adri=C3=A1n Garc=C3=ADa Casado (1):
      scsi: libsas: Add __printf attribute to sas_ata_printk()

Andrew Luebke (1):
      scsi: aic79xx: Fix NULL pointer dereference in device reset

Bart Van Assche (2):
      scsi: BusLogic: Pass the host pointer directly to several functions
      scsi: BusLogic: Prepare for enabling lock context analysis

Giuseppe Piscitelli (2):
      scsi: scsi_debug: Drain target cleanup before module exit
      scsi: core: Balance the pseudo target reap reference

HOYOUNG SEO (1):
      scsi: ufs: core: Change the error check sequence for auto hibern8

Imre Kaloz (2):
      scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian host=
s
      scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers

Jia Jia (1):
      scsi: target: Validate REGISTER AND MOVE TransportID length

Martin K. Petersen (Oracle) (1):
      Merge branch '7.4/scsi-queue' into 7.4/scsi-fixes

Matthew Whitehead (1):
      scsi: aha1542: Remove unneeded scsi_dma_unmap() call

Shao Mingyin (1):
      scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store

Vincent YUE (1):
      scsi: mpt3sas: Register devices during SANITIZE

Yingjie Wang (2):
      scsi: bsg: Report synchronous data copyback failures
      scsi: bsg: Report io_uring data copyback failures

Yu Zhang (1):
      scsi: target: Fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown

Yuanhe Shu (1):
      scsi: target: Verify the iSCSI ISID is null-terminated

 drivers/scsi/BusLogic.c                 | 99 ++++++++++++++++++++---------=
----
 drivers/scsi/BusLogic.h                 |  3 +-
 drivers/scsi/aha1542.c                  |  2 -
 drivers/scsi/aic7xxx/aic79xx_core.c     |  4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h      | 26 +++++++--
 drivers/scsi/aic7xxx/aic7xxx_core.c     | 10 +++-
 drivers/scsi/aic7xxx/aic7xxx_pci.c      | 20 ++++++-
 drivers/scsi/libsas/sas_ata.c           |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c    |  4 +-
 drivers/scsi/scsi_bsg.c                 |  8 ++-
 drivers/scsi/scsi_debug.c               |  1 +
 drivers/scsi/scsi_scan.c                |  5 +-
 drivers/target/target_core_device.c     | 18 +++++-
 drivers/target/target_core_fabric_lib.c | 10 ++++
 drivers/target/target_core_pr.c         |  9 +--
 drivers/target/target_core_tpg.c        | 10 +++-
 drivers/target/target_core_user.c       |  5 ++
 drivers/ufs/core/ufshcd.c               | 18 ++++--
 18 files changed, 180 insertions(+), 73 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 27b446c0c5d0..4179f29b3066 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -276,8 +276,10 @@ static void blogic_create_addlccbs(struct blogic_adapt=
er *adapter,
   Lock should already have been acquired by the caller.
 */
=20
-static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)
+static struct blogic_ccb *blogic_alloc_ccb(struct Scsi_Host *host)
+	__must_hold(&host->host_lock)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	static unsigned long serial;
 	struct blogic_ccb *ccb;
 	ccb =3D adapter->free_ccbs;
@@ -307,7 +309,9 @@ static struct blogic_ccb *blogic_alloc_ccb(struct blogi=
c_adapter *adapter)
   caller.
 */
=20
-static void blogic_dealloc_ccb(struct blogic_ccb *ccb, int dma_unmap)
+static void blogic_dealloc_ccb(struct Scsi_Host *host, struct blogic_ccb *=
ccb,
+			       int dma_unmap)
+	__must_hold(&host->host_lock)
 {
 	struct blogic_adapter *adapter =3D ccb->adapter;
=20
@@ -2596,8 +2600,11 @@ static void blogic_scan_inbox(struct blogic_adapter =
*adapter)
   should already have been acquired by the caller.
 */
=20
-static void blogic_process_ccbs(struct blogic_adapter *adapter)
+static void blogic_process_ccbs(struct Scsi_Host *host)
+	__must_hold(&host->host_lock)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
+
 	if (adapter->processing_ccbs)
 		return;
 	adapter->processing_ccbs =3D true;
@@ -2621,7 +2628,7 @@ static void blogic_process_ccbs(struct blogic_adapter=
 *adapter)
 			/*
 			   Place CCB back on the Host Adapter's free list.
 			 */
-			blogic_dealloc_ccb(ccb, 1);
+			blogic_dealloc_ccb(host, ccb, 1);
 #if 0			/* this needs to be redone different for new EH */
 			/*
 			   Bus Device Reset CCBs have the command field
@@ -2650,7 +2657,7 @@ static void blogic_process_ccbs(struct blogic_adapter=
 *adapter)
 				if (ccb->status =3D=3D BLOGIC_CCB_RESET &&
 						ccb->tgt_id =3D=3D tgt_id) {
 					command =3D ccb->command;
-					blogic_dealloc_ccb(ccb, 1);
+					blogic_dealloc_ccb(host, ccb, 1);
 					adapter->active_cmds[tgt_id]--;
 					command->result =3D DID_RESET << 16;
 					scsi_done(command);
@@ -2721,7 +2728,7 @@ static void blogic_process_ccbs(struct blogic_adapter=
 *adapter)
 			/*
 			   Place CCB back on the Host Adapter's free list.
 			 */
-			blogic_dealloc_ccb(ccb, 1);
+			blogic_dealloc_ccb(host, ccb, 1);
 			/*
 			   Call the SCSI Command Completion Routine.
 			 */
@@ -2740,11 +2747,12 @@ static void blogic_process_ccbs(struct blogic_adapt=
er *adapter)
 static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
 {
 	struct blogic_adapter *adapter =3D (struct blogic_adapter *) devid;
+	struct Scsi_Host *host =3D adapter->scsi_host;
 	unsigned long processor_flag;
 	/*
 	   Acquire exclusive access to Host Adapter.
 	 */
-	spin_lock_irqsave(&adapter->scsi_host->host_lock, processor_flag);
+	spin_lock_irqsave(&host->host_lock, processor_flag);
 	/*
 	   Handle Interrupts appropriately for each Host Adapter type.
 	 */
@@ -2794,25 +2802,25 @@ static irqreturn_t blogic_inthandler(int irq_ch, vo=
id *devid)
 	   Process any completed CCBs.
 	 */
 	if (adapter->firstccb !=3D NULL)
-		blogic_process_ccbs(adapter);
+		blogic_process_ccbs(host);
 	/*
 	   Reset the Host Adapter if requested.
 	 */
 	if (adapter->adapter_extreset) {
 		blogic_warn("Resetting %s due to External SCSI Bus Reset\n", adapter, ad=
apter->full_model);
 		blogic_inc_count(&adapter->ext_resets);
-		blogic_resetadapter(adapter, false);
+		blogic_resetadapter(host, false);
 		adapter->adapter_extreset =3D false;
 	} else if (adapter->adapter_intern_err) {
 		blogic_warn("Resetting %s due to Host Adapter Internal Error\n", adapter=
, adapter->full_model);
 		blogic_inc_count(&adapter->adapter_intern_errors);
-		blogic_resetadapter(adapter, true);
+		blogic_resetadapter(host, true);
 		adapter->adapter_intern_err =3D false;
 	}
 	/*
 	   Release exclusive access to Host Adapter.
 	 */
-	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, processor_flag);
+	spin_unlock_irqrestore(&host->host_lock, processor_flag);
 	return IRQ_HANDLED;
 }
=20
@@ -2823,9 +2831,11 @@ static irqreturn_t blogic_inthandler(int irq_ch, voi=
d *devid)
   already have been acquired by the caller.
 */
=20
-static bool blogic_write_outbox(struct blogic_adapter *adapter,
+static bool blogic_write_outbox(struct Scsi_Host *host,
 		enum blogic_action action, struct blogic_ccb *ccb)
+	__must_hold(&host->host_lock)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	struct blogic_outbox *next_outbox;
=20
 	next_outbox =3D adapter->next_outbox;
@@ -2859,17 +2869,16 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt=
)
 {
 	struct blogic_adapter *adapter =3D
 		(struct blogic_adapter *) SCpnt->device->host->hostdata;
-
+	struct Scsi_Host *shost =3D adapter->scsi_host;
 	unsigned int id =3D SCpnt->device->id;
 	struct blogic_tgt_stats *stats =3D &adapter->tgt_stats[id];
 	int rc;
=20
-	spin_lock_irq(&SCpnt->device->host->host_lock);
-
+	spin_lock_irq(&shost->host_lock);
 	blogic_inc_count(&stats->adapter_reset_req);
+	rc =3D blogic_resetadapter(shost, false);
+	spin_unlock_irq(&shost->host_lock);
=20
-	rc =3D blogic_resetadapter(adapter, false);
-	spin_unlock_irq(&SCpnt->device->host->host_lock);
 	return rc;
 }
=20
@@ -2878,11 +2887,12 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt=
)
   Outgoing Mailbox for execution by the associated Host Adapter.
 */
=20
-static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
+static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, struct=
 scsi_cmnd *command)
+	__must_hold(&shost->host_lock)
 {
 	void (*comp_cb)(struct scsi_cmnd *) =3D scsi_done;
 	struct blogic_adapter *adapter =3D
-		(struct blogic_adapter *) command->device->host->hostdata;
+		(struct blogic_adapter *) shost->hostdata;
 	struct blogic_tgt_flags *tgt_flags =3D
 		&adapter->tgt_flags[command->device->id];
 	struct blogic_tgt_stats *tgt_stats =3D adapter->tgt_stats;
@@ -2913,12 +2923,12 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 	   probably hung so signal an error as a Host Adapter Hard Reset
 	   should be initiated soon.
 	 */
-	ccb =3D blogic_alloc_ccb(adapter);
+	ccb =3D blogic_alloc_ccb(shost);
 	if (ccb =3D=3D NULL) {
-		spin_unlock_irq(&adapter->scsi_host->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		blogic_delay(1);
-		spin_lock_irq(&adapter->scsi_host->host_lock);
-		ccb =3D blogic_alloc_ccb(adapter);
+		spin_lock_irq(&shost->host_lock);
+		ccb =3D blogic_alloc_ccb(shost);
 		if (ccb =3D=3D NULL) {
 			command->result =3D DID_ERROR << 16;
 			comp_cb(command);
@@ -3046,7 +3056,7 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scs=
i_cmnd *command)
 	if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
 		blogic_err("DMA mapping for sense data buffer failed\n",
 				adapter);
-		blogic_dealloc_ccb(ccb, 0);
+		blogic_dealloc_ccb(shost, ccb, 0);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	ccb->sensedata =3D sense_buf;
@@ -3061,15 +3071,15 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 		   so signal an error as a Host Adapter Hard Reset should
 		   be initiated soon.
 		 */
-		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
-			spin_unlock_irq(&adapter->scsi_host->host_lock);
+		if (!blogic_write_outbox(shost, BLOGIC_MBOX_START, ccb)) {
+			spin_unlock_irq(&shost->host_lock);
 			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n"=
, adapter);
 			blogic_delay(1);
-			spin_lock_irq(&adapter->scsi_host->host_lock);
-			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
+			spin_lock_irq(&shost->host_lock);
+			if (!blogic_write_outbox(shost, BLOGIC_MBOX_START,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dea=
d?\n", adapter);
-				blogic_dealloc_ccb(ccb, 1);
+				blogic_dealloc_ccb(shost, ccb, 1);
 				command->result =3D DID_ERROR << 16;
 				scsi_done(command);
 			}
@@ -3089,12 +3099,20 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 		   pending.
 		 */
 		if (ccb->status =3D=3D BLOGIC_CCB_COMPLETE)
-			blogic_process_ccbs(adapter);
+			blogic_process_ccbs(shost);
 	}
 	return 0;
 }
=20
-static DEF_SCSI_QCMD(blogic_qcmd)
+static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *shost, struct scs=
i_cmnd *cmd)
+{
+	enum scsi_qc_status rc;
+
+	spin_lock_irq(&shost->host_lock);
+	rc =3D blogic_qcmd_lck(shost, cmd);
+	spin_unlock_irq(&shost->host_lock);
+	return rc;
+}
=20
 #if 0
 /*
@@ -3103,9 +3121,8 @@ static DEF_SCSI_QCMD(blogic_qcmd)
=20
 static int blogic_abort(struct scsi_cmnd *command)
 {
-	struct blogic_adapter *adapter =3D
-		(struct blogic_adapter *) command->device->host->hostdata;
-
+	struct Scsi_Host *const shost =3D command->device->host;
+	struct blogic_adapter *adapter =3D (void *) shost->hostdata;
 	int tgt_id =3D command->device->id;
 	struct blogic_ccb *ccb;
 	blogic_inc_count(&adapter->tgt_stats[tgt_id].aborts_request);
@@ -3144,7 +3161,7 @@ static int blogic_abort(struct scsi_cmnd *command)
 				adapter->fw_ver[0] < '5') {
 			blogic_warn("Unable to Abort CCB #%ld to Target %d - Abort Tag Not Supp=
orted\n", adapter, ccb->serial, tgt_id);
 			return FAILURE;
-		} else if (blogic_write_outbox(adapter, BLOGIC_MBOX_ABORT,
+		} else if (blogic_write_outbox(shost, BLOGIC_MBOX_ABORT,
 					ccb)) {
 			blogic_warn("Aborting CCB #%ld to Target %d\n",
 					adapter, ccb->serial, tgt_id);
@@ -3169,7 +3186,7 @@ static int blogic_abort(struct scsi_cmnd *command)
 		   may still be pending.
 		 */
 		if (ccb->status =3D=3D BLOGIC_CCB_COMPLETE)
-			blogic_process_ccbs(adapter);
+			blogic_process_ccbs(shost);
 		return SUCCESS;
 	}
 	return SUCCESS;
@@ -3181,8 +3198,10 @@ static int blogic_abort(struct scsi_cmnd *command)
   currently executing SCSI Commands as having been Reset.
 */
=20
-static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_r=
eset)
+static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
+	__must_hold(&host->host_lock)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	struct blogic_ccb *ccb;
 	int tgt_id;
=20
@@ -3203,7 +3222,7 @@ static int blogic_resetadapter(struct blogic_adapter =
*adapter, bool hard_reset)
=20
 	for (ccb =3D adapter->all_ccbs; ccb !=3D NULL; ccb =3D ccb->next_all)
 		if (ccb->status =3D=3D BLOGIC_CCB_ACTIVE)
-			blogic_dealloc_ccb(ccb, 1);
+			blogic_dealloc_ccb(host, ccb, 1);
 	/*
 	 * Wait a few seconds between the Host Adapter Hard Reset which
 	 * initiates a SCSI Bus Reset and issuing any SCSI Commands.  Some
@@ -3212,9 +3231,9 @@ static int blogic_resetadapter(struct blogic_adapter =
*adapter, bool hard_reset)
 	 */
=20
 	if (hard_reset) {
-		spin_unlock_irq(&adapter->scsi_host->host_lock);
+		spin_unlock_irq(&host->host_lock);
 		blogic_delay(adapter->bus_settle_time);
-		spin_lock_irq(&adapter->scsi_host->host_lock);
+		spin_lock_irq(&host->host_lock);
 	}
=20
 	for (tgt_id =3D 0; tgt_id < adapter->maxdev; tgt_id++) {
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 24697a5bedc8..455d442525f6 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1279,7 +1279,8 @@ static int blogic_sdev_configure(struct scsi_device *=
,
 				 struct queue_limits *lim);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
-static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
+static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
+	__must_hold(&host->host_lock);
 static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter=
 *, ...);
 static int __init blogic_setup(char *);
=20
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 7ea38d509072..8191d258f162 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -271,8 +271,6 @@ static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 			buf +=3D bv.bv_len;
 		}
 	}
-
-	scsi_dma_unmap(cmd);
 }
=20
 static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic=
79xx_core.c
index 3602a1fc40e4..4abc7948187f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8942,8 +8942,10 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct=
 scb *scb)
 		}
 #endif
=20
-		if (ahd_perform_autosense(scb) =3D=3D 0)
+		if (ahd_perform_autosense(scb) =3D=3D 0) {
+			ahd_done(ahd, scb);
 			break;
+		}
=20
 		ahd_compile_devinfo(&devinfo, SCB_GET_OUR_ID(scb),
 				    SCB_GET_TARGET(ahd, scb),
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic7=
9xx_osm.h
index c6eb2b97e929..1facfd238f89 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -501,6 +501,8 @@ int	ahd_linux_show_info(struct seq_file *,struct Scsi_H=
ost *);
 static inline
 void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status=
)
 {
+	if (!cmd)
+		return;
 	cmd->result &=3D ~(CAM_STATUS_MASK << 16);
 	cmd->result |=3D status << 16;
 }
@@ -514,6 +516,8 @@ void ahd_set_transaction_status(struct scb *scb, uint32=
_t status)
 static inline
 void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
+	if (!cmd)
+		return;
 	cmd->result &=3D ~0xFFFF;
 	cmd->result |=3D status;
 }
@@ -527,6 +531,8 @@ void ahd_set_scsi_status(struct scb *scb, uint32_t stat=
us)
 static inline
 uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
+	if (!cmd)
+		return CAM_REQ_INPROG;
 	return ((cmd->result >> 16) & CAM_STATUS_MASK);
 }
=20
@@ -539,6 +545,8 @@ uint32_t ahd_get_transaction_status(struct scb *scb)
 static inline
 uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
+	if (!cmd)
+		return SAM_STAT_GOOD;
 	return (cmd->result & 0xFFFF);
 }
=20
@@ -566,13 +574,16 @@ u_long ahd_get_transfer_length(struct scb *scb)
 static inline
 int ahd_get_transfer_dir(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return DMA_NONE;
 	return (scb->io_ctx->sc_data_direction);
 }
=20
 static inline
 void ahd_set_residual(struct scb *scb, u_long resid)
 {
-	scsi_set_resid(scb->io_ctx, resid);
+	if (scb->io_ctx)
+		scsi_set_resid(scb->io_ctx, resid);
 }
=20
 static inline
@@ -584,6 +595,8 @@ void ahd_set_sense_residual(struct scb *scb, u_long res=
id)
 static inline
 u_long ahd_get_residual(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return 0;
 	return scsi_get_resid(scb->io_ctx);
 }
=20
@@ -597,11 +610,12 @@ static inline
 int ahd_perform_autosense(struct scb *scb)
 {
 	/*
-	 * We always perform autosense in Linux.
-	 * On other platforms this is set on a
-	 * per-transaction basis.
+	 * We always perform autosense in Linux, except for the device
+	 * reset SCB, which has no command to return sense data to.
 	 */
-	return (1);
+	if (!scb->io_ctx)
+		return 0;
+	return 1;
 }
=20
 static inline uint32_t
@@ -631,6 +645,8 @@ void	ahd_platform_freeze_devq(struct ahd_softc *ahd, st=
ruct scb *scb);
 static inline void
 ahd_freeze_scb(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return;
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) =3D=3D 0) {
 		scb->io_ctx->result |=3D CAM_DEV_QFRZN << 16;
 		scb->platform_data->dev->qfrozen++;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic=
7xxx_core.c
index b9761f9f0bbc..af6115bfb280 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1097,7 +1097,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intsta=
t)
 				sc->byte2 =3D SCB_GET_LUN(scb) << 5;
 			sc->unused[0] =3D 0;
 			sc->unused[1] =3D 0;
-			sc->length =3D sg->len;
+			sc->length =3D ahc_get_sense_bufsize(ahc, scb);
 			sc->control =3D 0;
=20
 			/*
@@ -5266,9 +5266,13 @@ ahc_init(struct ahc_softc *ahc)
=20
 	/*
 	 * Assume we have a board at this stage and it has been reset.
+	 * PCI controllers keep the host ID ahc_pci_config() chose.
 	 */
-	if ((ahc->flags & AHC_USEDEFAULTS) !=3D 0)
-		ahc->our_id =3D ahc->our_id_b =3D 7;
+	if ((ahc->flags & AHC_USEDEFAULTS) !=3D 0) {
+		if ((ahc->chip & AHC_PCI) =3D=3D 0)
+			ahc->our_id =3D 7;
+		ahc->our_id_b =3D 7;
+	}
=20
 	/*
 	 * Default to allowing initiator operations.
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7=
xxx_pci.c
index 2d4c85426dc3..5a04c7d55e4b 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -701,6 +701,21 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 	return (NULL);
 }
=20
+/*
+ * The SGI O2 firmware runs its onboard controllers, in slots 1 and 2 of t=
he
+ * root bus, without the Adaptec BIOS and at host ID 0.  It leaves no sett=
ings
+ * in scratch RAM, which may still hold power-on contents with bad parity.
+ */
+static bool
+ahc_pci_sgi_o2_onboard(struct ahc_softc *ahc)
+{
+	int slot =3D ahc_get_pci_slot(ahc->dev_softc);
+
+	return IS_ENABLED(CONFIG_SGI_IP32) &&
+	       ahc_get_pci_bus(ahc->dev_softc) =3D=3D 0 &&
+	       (slot =3D=3D 1 || slot =3D=3D 2);
+}
+
 int
 ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry=
)
 {
@@ -782,6 +797,9 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_=
pci_identity *entry)
 	ahc->bus_intr =3D ahc_pci_intr;
 	ahc->bus_chip_init =3D ahc_pci_chip_init;
=20
+	if (ahc_pci_sgi_o2_onboard(ahc))
+		ahc->flags |=3D AHC_NO_BIOS_INIT;
+
 	/* Remember how the card was setup in case there is no SEEPROM */
 	if ((ahc_inb(ahc, HCNTRL) & POWRDN) =3D=3D 0) {
 		ahc_pause(ahc);
@@ -898,7 +916,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_=
pci_identity *entry)
 			 * Assume only one connector and always turn
 			 * on termination.
 			 */
- 			our_id =3D 0x07;
+			our_id =3D ahc_pci_sgi_o2_onboard(ahc) ? 0 : 0x07;
 			sxfrctl1 =3D STPWEN;
 		}
 		ahc_outb(ahc, SCSICONF, our_id|ENSPCHK|RESET_SCSI);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2340790c9f6b..8f5f1ef6f619 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -372,6 +372,7 @@ static int local_ata_check_ready(struct ata_link *link)
 	}
 }
=20
+__printf(3, 4)
 static int sas_ata_printk(const char *level, const struct domain_device *d=
dev,
 			  const char *fmt, ...)
 {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mp=
t3sas_scsih.c
index 085d4672db85..a77bbc3d2b66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7700,7 +7700,9 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPTER *=
ioc,
 				u16 scode =3D scsi_sense_code(sense_info.asc,
 							    sense_info.ascq);
=20
-				if (scode =3D=3D
+				if (scode =3D=3D LU_NOT_READY_SANITIZE_IN_PROGRESS)
+					rc =3D DEVICE_READY;
+				else if (scode =3D=3D
 				    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED ||
 				    scode =3D=3D
 				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE ||
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 5eec248a77a6..e4a65d7a2374 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -41,7 +41,7 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_re=
q, io_tw_token_t tw)
 	u8 sense_len_wr =3D 0;
=20
 	if (pdu->bio)
-		blk_rq_unmap_user(pdu->bio);
+		ret =3D blk_rq_unmap_user(pdu->bio);
=20
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status =3D DRIVER_SENSE;
@@ -199,7 +199,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, s=
truct sg_io_v4 *hdr,
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
-	int ret;
+	int ret, unmap_ret;
=20
 	if (hdr->protocol !=3D BSG_PROTOCOL_SCSI  ||
 	    hdr->subprotocol !=3D BSG_SUB_PROTOCOL_SCSI_CMD)
@@ -273,7 +273,9 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, s=
truct sg_io_v4 *hdr,
 	else
 		hdr->dout_resid =3D scmd->resid_len;
=20
-	blk_rq_unmap_user(bio);
+	unmap_ret =3D blk_rq_unmap_user(bio);
+	if (!ret)
+		ret =3D unmap_ret;
=20
 out_put_request:
 	blk_mq_free_request(rq);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a922c8318a2f..c5c4312e23aa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9053,6 +9053,7 @@ static void __exit scsi_debug_exit(void)
=20
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	async_synchronize_full_domain(&sdebug_async_domain);
 	debugfs_remove(sdebug_debugfs_root);
 }
=20
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8aae12fd38f3..52f3b525d2fd 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -2154,14 +2154,13 @@ struct scsi_device *scsi_get_pseudo_sdev(struct Scs=
i_Host *shost)
 		goto out;
=20
 	sdev =3D scsi_alloc_sdev(starget, U64_MAX, NULL);
-	if (!sdev) {
-		scsi_target_reap(starget);
+	if (!sdev)
 		goto put_target;
-	}
=20
 	sdev->borken =3D 0;
=20
 put_target:
+	scsi_target_reap(starget);
 	/* See also the get_device(dev) call in scsi_alloc_target(). */
 	put_device(&starget->dev);
=20
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_co=
re_device.c
index 9db2201aa553..c5d5d6a91fee 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -349,6 +349,19 @@ int core_enable_device_list_for_node(
 	new->attach_count++;
=20
 	mutex_lock(&nacl->lun_entry_mutex);
+	/*
+	 * Do not attach a new dev entry to an se_lun that is being torn down.
+	 * lun_shutdown is set by core_tpg_remove_lun() before its
+	 * core_clear_lun_from_tpg() sweep; checking it here under the same
+	 * nacl->lun_entry_mutex the sweep takes guarantees that once the sweep
+	 * has passed this ACL no dev entry can be left dangling on the
+	 * se_lun->lun_deve_list that is about to be freed.
+	 */
+	if (lun->lun_shutdown) {
+		mutex_unlock(&nacl->lun_entry_mutex);
+		ret =3D -ENODEV;
+		goto free_stats;
+	}
 	orig =3D target_nacl_find_deve(nacl, mapped_lun);
 	if (orig && orig->se_lun) {
 		struct se_lun *orig_lun =3D orig->se_lun;
@@ -375,12 +388,12 @@ int core_enable_device_list_for_node(
 		new->se_lun_acl =3D lun_acl;
 		hlist_del_rcu(&orig->link);
 		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
-		mutex_unlock(&nacl->lun_entry_mutex);
=20
 		spin_lock(&lun->lun_deve_lock);
 		list_del(&orig->lun_link);
 		list_add_tail(&new->lun_link, &lun->lun_deve_list);
 		spin_unlock(&lun->lun_deve_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
=20
 		kref_put(&orig->pr_kref, target_pr_kref_release);
 		wait_for_completion(&orig->pr_comp);
@@ -393,11 +406,10 @@ int core_enable_device_list_for_node(
 	new->se_lun =3D lun;
 	new->se_lun_acl =3D lun_acl;
 	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
-	mutex_unlock(&nacl->lun_entry_mutex);
-
 	spin_lock(&lun->lun_deve_lock);
 	list_add_tail(&new->lun_link, &lun->lun_deve_list);
 	spin_unlock(&lun->lun_deve_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
=20
 	target_luns_data_has_changed(nacl, new, true);
 	return 0;
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/targe=
t_core_fabric_lib.c
index 2853b95b2c59..ad024009df56 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -371,6 +371,16 @@ static bool iscsi_parse_pr_out_transport_id(
 			pr_err("Missing ISID in iSCSI Initiator port TransportID\n");
 			return false;
 		}
+		/*
+		 * The registration code reads the ISID as a C string,
+		 * and its first 8 bytes with get_unaligned_be64(), so
+		 * require 8 bytes after the separator and a NUL inside
+		 * the rest of the descriptor.
+		 */
+		if (buf + tid_len - p < 8 || !memchr(p, '\0', buf + tid_len - p)) {
+			pr_err("Incomplete or unterminated ISID in iSCSI Initiator port Transpo=
rtID\n");
+			return false;
+		}
 		*port_nexus_ptr =3D p;
 		/*
 		 * Go ahead and do the lower case conversion of the received
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_p=
r.c
index 25b1bcacc0c8..ca1a2802aa22 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3226,10 +3226,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_=
cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf =3D NULL;
=20
-	if ((tid_len + 24) !=3D cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+	/* TransportID is at least 24 bytes. buf[24] is its first byte. */
+	if (tid_len < 24 ||
+	    tid_len !=3D cmd->data_length - 24) {
+		pr_err("SPC-3 PR: Illegal tid_len: %u for data_length: %u\n",
+		       tid_len, cmd->data_length);
 		ret =3D TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_=
tpg.c
index ccff9f6e4826..e615e5e30427 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -266,6 +266,15 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	kref_get(&acl->acl_kref);
 	acl->dynamic_node_acl =3D 1;
=20
+	/*
+	 * Publish the dynamic NodeACL on tpg->acl_node_list before creating
+	 * its demo-mode MappedLUN dev entries below, so that a concurrent LUN
+	 * teardown sweep (core_clear_lun_from_tpg(), which walks acl_node_list)
+	 * can observe and disable those dev entries.  Otherwise a dev entry can
+	 * be left on an se_lun->lun_deve_list that is about to be freed.
+	 */
+	target_add_node_acl(acl);
+
 	/*
 	 * Here we only create demo-mode MappedLUNs from the active
 	 * TPG LUNs if the fabric is not explicitly asking for
@@ -275,7 +284,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) !=3D 1))
 		core_tpg_add_node_to_devs(acl, tpg, NULL);
=20
-	target_add_node_acl(acl);
 	return acl;
 }
 EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core=
_user.c
index 425ad1246a75..07b514678176 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2524,6 +2524,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_d=
ev *udev, substring_t *arg)
 		return ret;
 	}
=20
+	if (val <=3D 0) {
+		pr_err("Invalid data_pages_per_blk %d.\n", val);
+		return -EINVAL;
+	}
+
 	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
 		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d =
-> %zd pages).\n",
 		       val, udev->data_area_mb,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..fd52deb72d21 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5931,18 +5931,26 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
 {
 	irqreturn_t retval =3D IRQ_NONE;
 	struct uic_command *cmd;
+	bool ah8_err;
=20
 	guard(spinlock_irqsave)(&hba->host->host_lock);
+
+	/*
+	 * Auto-hibern8 is performed without a UIC command, so check for
+	 * auto-hibern8 errors before checking for an active UIC command.
+	 */
+	ah8_err =3D ufshcd_is_auto_hibern8_error(hba, intr_status);
+	if (ah8_err)
+		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	cmd =3D hba->active_uic_cmd;
 	if (!cmd) {
-		dev_err(hba->dev,
-			"No active UIC command. Maybe a timeout occurred?\n");
+		if (!ah8_err)
+			dev_err(hba->dev,
+				"No active UIC command. Maybe a timeout occurred?\n");
 		return retval;
 	}
=20
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
 	if (intr_status & UIC_COMMAND_COMPL) {
 		/*
 		 * Store the UIC command result in the lowest byte of

