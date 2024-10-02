Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F056A81720
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901345; cv=none; b=iCzzyZ2bTiTFAyO/TW1xvkblFgCSSh17g9/ropfYQ/QvKc8iGov+jo7RNx7NztM1cK7rWE+YjGtrOtmxpZYb0BIB2Vgca/g078Gdxapv2dyTkY9MUVrtPshwGJRQNrpDWiFIdXAW7+qzI0+VOI3tV6YJac9YUTFVoIqIZ4Mk2NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901345; c=relaxed/simple;
	bh=Ue1Ne6GOaGmZVRlNhOyVn9zz+iQQknK7UyO8+kzXQyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkY2m+2CcAVTzpmi1ormBZJGetj++YOR6X6nLdCDJaVOqp5prezChgP4R4yWEGB1lRNU/TDfis1d/zbSiRYUJ3+Wl/5jZIokcoAjgiofVCYbofIiVGP1Ctft/s19Ud1qxG9RCXAxKeCvaHK70Jv673h/ZHOGmN7cKO0lVk9wDi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T4FtacfH; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T4FtacfH"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmlz4zl6zlgMWB;
	Wed,  2 Oct 2024 20:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727901340; x=1730493341; bh=Dy6A0
	G3Y2ZEBHTZNXV+Hc18RRQiSqlb2jsITLR/He+0=; b=T4FtacfH+IrbBkqd4bz6h
	gX2UFCFLrx9NrX7akAKtXISmxUw/csxtOPuuymGo9R54ypmyC292s3FPpbYWeC/P
	k40kIlyyYO/dcObcUP0Ytm/hEn7l99F36fbyh8PRITiBFvhiMMDD0R44FNUrOUEA
	qGqEsLggjLdLcjpFUBQeu5VnphRRnIGTupdN5B/lbRoU26nxSUY6fKQX6vv3mTeE
	n4oCIFVqdRty0kKtK436e2LTlD2f+hZt2po7nGs99TYzI3wiMg9AcVCYrdy6/5Ng
	iktGHt6hXzusf/5JY5NO/kTCkNoYw7Zelk0H/pskqDbK3wFDhVPTK9Of9/rwllaU
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XqHjONH6pVLV; Wed,  2 Oct 2024 20:35:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmlv6MNpzlgMW9;
	Wed,  2 Oct 2024 20:35:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 01/11] scsi: arcmsr: Remove the changelog
Date: Wed,  2 Oct 2024 13:33:53 -0700
Message-ID: <20241002203528.4104996-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20241002203528.4104996-1-bvanassche@acm.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since we typically do not maintain changelogs as text files in the kernel=
,
and since the arcmsr changelog has not been updated since 2008, remove it=
.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/ChangeLog.arcmsr | 118 ----------------------------
 1 file changed, 118 deletions(-)
 delete mode 100644 Documentation/scsi/ChangeLog.arcmsr

diff --git a/Documentation/scsi/ChangeLog.arcmsr b/Documentation/scsi/Cha=
ngeLog.arcmsr
deleted file mode 100644
index 038a3e6ecaa4..000000000000
--- a/Documentation/scsi/ChangeLog.arcmsr
+++ /dev/null
@@ -1,118 +0,0 @@
-************************************************************************=
**
-** History
-**
-**   REV#         DATE             NAME         DESCRIPTION
-** 1.00.00.00    3/31/2004       Erich Chen     First release
-** 1.10.00.04    7/28/2004       Erich Chen     modify for ioctl
-** 1.10.00.06    8/28/2004       Erich Chen     modify for 2.6.x
-** 1.10.00.08    9/28/2004       Erich Chen     modify for x86_64
-** 1.10.00.10   10/10/2004       Erich Chen     bug fix for SMP & ioctl
-** 1.20.00.00   11/29/2004       Erich Chen     bug fix with arcmsr_bus_=
reset when PHY error
-** 1.20.00.02   12/09/2004       Erich Chen     bug fix with over 2T byt=
es RAID Volume
-** 1.20.00.04    1/09/2005       Erich Chen     fits for Debian linux ke=
rnel version 2.2.xx
-** 1.20.00.05    2/20/2005       Erich Chen     cleanly as look like a L=
inux driver at 2.6.x
-**                                              thanks for peoples kindn=
ess comment
-**						Kornel Wieliczek
-**						Christoph Hellwig
-**						Adrian Bunk
-**						Andrew Morton
-**						Christoph Hellwig
-**						James Bottomley
-**						Arjan van de Ven
-** 1.20.00.06    3/12/2005       Erich Chen     fix with arcmsr_pci_unma=
p_dma "unsigned long" cast,
-**						modify PCCB POOL allocated by "dma_alloc_coherent"
-**						(Kornel Wieliczek's comment)
-** 1.20.00.07    3/23/2005       Erich Chen     bug fix with arcmsr_scsi=
_host_template_init
-**						occur segmentation fault,
-**						if RAID adapter does not on PCI slot
-**						and modprobe/rmmod this driver twice.
-**						bug fix enormous stack usage (Adrian Bunk's comment)
-** 1.20.00.08    6/23/2005       Erich Chen     bug fix with abort comma=
nd,
-**						in case of heavy loading when sata cable
-**						working on low quality connection
-** 1.20.00.09    9/12/2005       Erich Chen     bug fix with abort comma=
nd handling, firmware version check
-**						and firmware update notify for hardware bug fix
-** 1.20.00.10    9/23/2005       Erich Chen     enhance sysfs function f=
or change driver's max tag Q number.
-**						add DMA_64BIT_MASK for backward compatible with all 2.6.x
-**						add some useful message for abort command
-**						add ioctl code 'ARCMSR_IOCTL_FLUSH_ADAPTER_CACHE'
-**						customer can send this command for sync raid volume data
-** 1.20.00.11    9/29/2005       Erich Chen     by comment of Arjan van =
de Ven fix incorrect msleep redefine
-**						cast off sizeof(dma_addr_t) condition for 64bit pci_set_dma_mask
-** 1.20.00.12    9/30/2005       Erich Chen     bug fix with 64bit platf=
orm's ccbs using if over 4G system memory
-**						change 64bit pci_set_consistent_dma_mask into 32bit
-**						increcct adapter count if adapter initialize fail.
-**						miss edit at arcmsr_build_ccb....
-**						psge +=3D sizeof(struct _SG64ENTRY *) =3D>
-**						psge +=3D sizeof(struct _SG64ENTRY)
-**						64 bits sg entry would be incorrectly calculated
-**						thanks Kornel Wieliczek give me kindly notify
-**						and detail description
-** 1.20.00.13   11/15/2005       Erich Chen     scheduling pending ccb w=
ith FIFO
-**						change the architecture of arcmsr command queue list
-**						for linux standard list
-**						enable usage of pci message signal interrupt
-**						follow Randy.Danlup kindness suggestion cleanup this code
-** 1.20.00.14   05/02/2007	 Erich Chen & Nick Cheng
-**						1.implement PCI-Express error recovery function and AER capabili=
ty
-**						2.implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096
-**				 		if firmware version is newer than 1.42
-**						3.modify arcmsr_iop_reset to improve the ability
-**						4.modify the ISR, arcmsr_interrupt routine,to prevent the
-**						inconsistency with sg_mod driver if application	directly calls
-**						the arcmsr driver w/o passing through scsi mid layer
-**						specially thanks to Yanmin Zhang's openhanded help about AER
-** 1.20.00.15   08/30/2007	 Erich Chen & Nick Cheng
-**						1. support ARC1200/1201/1202 SATA RAID adapter, which is named
-**						ACB_ADAPTER_TYPE_B
-**						2. modify the arcmsr_pci_slot_reset function
-**						3. modify the arcmsr_pci_ers_disconnect_forepart function
-**						4. modify the arcmsr_pci_ers_need_reset_forepart function
-** 1.20.00.15   09/27/2007	 Erich Chen & Nick Cheng
-**						1. add arcmsr_enable_eoi_mode() on adapter Type B
-** 						2. add readl(reg->iop2drv_doorbell_reg) in arcmsr_handle_hbb_is=
r()
-**						in case of the doorbell interrupt clearance is cached
-** 1.20.00.15   10/01/2007	 Erich Chen & Nick Cheng
-**						1. modify acb->devstate[i][j]
-**						as ARECA_RAID_GOOD instead of
-**						ARECA_RAID_GONE in arcmsr_alloc_ccb_pool
-** 1.20.00.15   11/06/2007       Erich Chen & Nick Cheng
-**						1. add conditional declaration for
-** 						arcmsr_pci_error_detected() and
-**						arcmsr_pci_slot_reset
-** 1.20.00.15	11/23/2007       Erich Chen & Nick Cheng
-**						1.check if the sg list member number
-**						exceeds arcmsr default limit in arcmsr_build_ccb()
-**						2.change the returned value type of arcmsr_build_ccb()
-**						from "void" to "int"
-**						3.add the conditional check if arcmsr_build_ccb()
-**						returns FAILED
-** 1.20.00.15	12/04/2007	 Erich Chen & Nick Cheng
-**						1. modify arcmsr_drain_donequeue() to ignore unknown
-**						command and let kernel process command timeout.
-**						This could handle IO request violating max. segments
-**						while Linux XFS over DM-CRYPT.
-**						Thanks to Milan Broz's comments <mbroz@redhat.com>
-** 1.20.00.15	12/24/2007	 Erich Chen & Nick Cheng
-**						1.fix the portability problems
-**						2.fix type B where we should _not_ iounmap() acb->pmu;
-**						it's not ioremapped.
-**						3.add return -ENOMEM if ioremap() fails
-**						4.transfer IS_SG64_ADDR w/ cpu_to_le32()
-**						in arcmsr_build_ccb
-**						5. modify acb->devstate[i][j] as ARECA_RAID_GONE instead of
-**						ARECA_RAID_GOOD in arcmsr_alloc_ccb_pool()
-**						6.fix arcmsr_cdb->Context as (unsigned long)arcmsr_cdb
-**						7.add the checking state of
-**						(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT) =3D=3D 0
-**						in arcmsr_handle_hba_isr
-**						8.replace pci_alloc_consistent()/pci_free_consistent() with kmal=
loc()/kfree() in arcmsr_iop_message_xfer()
-**						9. fix the release of dma memory for type B in arcmsr_free_ccb_p=
ool()
-**						10.fix the arcmsr_polling_hbb_ccbdone()
-** 1.20.00.15	02/27/2008	Erich Chen & Nick Cheng
-**						1.arcmsr_iop_message_xfer() is called from atomic context under =
the
-**						queuecommand scsi_host_template handler. James Bottomley pointed=
 out
-**						that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we =
are in
-**						atomic context, secondly this memory is not used for DMA.
-**						Also removed some unneeded casts. Thanks to Daniel Drake <dsd@ge=
ntoo.org>
-************************************************************************=
**
