Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794361737;
	b=e5TXi8fIw8Kqc68ayWB2fDp3aNZ6SZzDnW8CofU1lPAEJcag4QL3xOrbWY5F3UNB6Skg
	 80FJHuYIb9oqfAYktJKJuyrDV876tRk3ElLGtWDfWrFmEAUVAybChTOPnKEf0TwWEB5EH
	 RuKfUBiz8/LH+T+1DNEmYvwGXAJ6LsSGXD1mph2LPjS6jRth9HdIxJ4Xzne1R+fc4+T3B
	 hTlrCsFghzuyzTQjnCxat/z438SukA2UewAzFNEMMRZxBf0MZlI8WtTonxdlcVzEOrTfv
	 VD4AZduTeBBZ78Oj0veyYwjlCuR0/Xveo86qLaaIgJyqAitMZkIjc5og2lTVVaCX4Jg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794361737;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=33WJWI75AX3YWacDJW2bzE3Ity7fXYUwNoTbBEoJL7o=;
	b=G/TEs5oMAVjpfS18Foc/RKzcFp8qAaiL2MONNbZ/k9vt98T3KWSp15q2GvP45QE9GAwT
	 kt4QYS1sMkPN+OXu49xIzLHM6GOjILdlPgxa3V4YoBKNnG5xCJXJURZwfDYyTrjSF3AeA
	 CVfXgDL/BLAJkL9jkfgJcPiZcARtOMaonxI68MpWFcvbCVNFqLedwUX1QB/HsQsIuR6Qc
	 gdryonRPDLs2Ejt2kN6uTO8mFCl0pH8GqGD6R5jRZtwKRx83wlBJMTx5hiil33Bq5plYO
	 rDHudO87YGk605dsOSxKkR0Ipt0Rxc56stOLAnd4KL9lAO8pLU+4T3fhkoJt8SKjy0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjTJLgA+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9D606A31C;
	Wed, 11 Nov 2026 01:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjTJLgA+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794361737;
	b=hxtEcRMm67qDgcXRy2hBozdOR2rsbnOQB2qgXMmdo01UOckobD8Iesw9tF1YrELVYYHi
	 6bRTFDsN1j/2G+3FMWmYb5fS+OSG7fTiY9epYO2/NeK/2iriLasz9ZGfYdfgrtzURrrSQ
	 Wy5PBVztrEZXg8m7YPB3buuKQ7QBOtUKEVtHOXOX/YRMzkC3gf+EoE5xfvNn15CJkdraE
	 wy7fhgA4uu9t8mfEProJphrGCNsu/x9BDZ6GBx8Qn60BTRuJbHuDAc0Po0liZdg+lil1i
	 cfpimW33BJNekRTza0YDaFt3AB3YiAicv6EafHIbZPuuAV8kdvvrI2I1e5G/yvUqRoA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794361737;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=33WJWI75AX3YWacDJW2bzE3Ity7fXYUwNoTbBEoJL7o=;
	b=SqIpMUmN5Ubt6KB/SfTbWMCEhQdNZzzu2eG+HX0QqMZsc1ppRhn0TcMVBLzOUN/7OuP/
	 0sU8q+Jh+1ufSdFNucFuQ9lgqmAMiLcJtw/1uAdccNWev7ru2MbkP0OOrcN8Kn2uK/Cag
	 70dfzE7XdIKZt+UV0iNRj7R8NLcwbiw9LyulzXbf3J511PgthkhqSLmTYcaddQhXH70bW
	 aVEy7M3ED7tns3bI4Tf/5ifjeKCYKFp6ZLko9CxZ8BdlIexjwv7XwJmqWpQQ32qFvGd1a
	 +foGsTBAwWX0JEBSOPfRd380OIxeEYYi91QTMgHD2a1/yNM5qvRYRxcZft34n6G1Ykw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 736EE1F0089F;
	Wed, 11 Nov 2026 01:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794361737;
	bh=33WJWI75AX3YWacDJW2bzE3Ity7fXYUwNoTbBEoJL7o=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=DjTJLgA+2iwpvBYpTUDBD8zNvU2wvqJXS/8sUN/RG9gpKEtn2V07wIWJde4n4h+/r
	 HpmeNQDVyBi2DnnnpYnBNER2YJ7NYbE1/xLoQmP4mS2BN8q1XOH88PpOK0aLXfQ1gZ
	 yW+U4Tr6FGz9aZ78FkV21uZc+fjoaKU0jNzigtVPswkh5ZQufxRSlMUxn4fo4tpSmN
	 rUc+Fu8lMx80Wx7PtHLdzkDhTDhsaMPxEFO33cmSJJP0ELipU7rL6S0qlqKw+nEHn9
	 ZrP9v4D69+yCDgWFZBaCFMwQLGXmoIUwyo2l5Ha5p/PSIs240qyR4ADjESfSjs6eKr
	 AjVxbwHQ0i9DQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DFEBF48D0B;
	Wed, 11 Nov 2026 01:48:55 +0000 (UTC)
From: Charlie Jenkins via B4 Relay <devnull+charjenkins.tesla.com@kernel.org>
Date: Tue, 10 Nov 2026 17:48:05 -0800
Subject: [PATCH] scsi: ufs: exynos: Access HCI regs only while core_clk is
 enabled
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261110-ufs_exynos_hci_order-v1-1-ce3cf68a74d5@tesla.com>
X-B4-Tracking: v=1; b=H4sIAFTJ82oC/yXMyw6CMBBG4Vchs7ZJC95fhZgGyl8ZF62ZEYIhv
 LtVl9/inJUUwlC6VisJZlbOqcDtKgpjl+4wPBRTbeujc86aKarH8k5Z/RjYZxkgxqK79GfbHOL
 +RCV9CiIvv217+1un/oHw+r5o2z7Z+44JeAAAAA==
X-Change-ID: 20261110-ufs_exynos_hci_order-0ea9b8035f47
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Chanho Park <chanho61.park@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Charlie Jenkins <charjenkins@tesla.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794361735; l=2641;
 i=charjenkins@tesla.com; s=20261111; h=from:subject:message-id;
 bh=LAh4uxWJEJlM8NfNlEbxljfVuT2qoU7HqStq10W2Hns=;
 b=haIPNM/jxHhhj/GSLWYwPRTnUfCL/f3zCVGefXGiNVccdK//pUwTS3Lc0hUuzWhloFIVkRzL2
 GZ1rf3a9tJkDF7Dr5ZTJtqe18buZ0G92aaoVtxpEGl/wjADim/B72k5
X-Developer-Key: i=charjenkins@tesla.com; a=ed25519;
 pk=UcHY2MxMlGrG4OWEpbHAPZ2iB7xhVAktL8U7+7y1MhU=
X-Endpoint-Received: by B4 Relay for charjenkins@tesla.com/20261111 with
 auth_id=1484
X-Original-From: Charlie Jenkins <charjenkins@tesla.com>
Reply-To: charjenkins@tesla.com
Content-Transfer-Encoding: 7bit

From: Charlie Jenkins <charjenkins@tesla.com>

The current clock setup attempts to program the HCI clock-stop registers
after the core clock has already been brought down. With this ordering
on a reboot, the HCI bus clock is stopped before the clock-stop
accesses, triggering an SError on the power-down path.

SError Interrupt on CPU5, code 0x00000000bf000002 -- SError
pc : readl+0x4/0x18
lr : hci_readl.isra.0+0x14/0x20
Kernel panic - not syncing: Asynchronous SError Interrupt
Call trace:
 readl+0x4/0x18
 exynos_ufs_ctrl_clkstop+0x30/0xac
 exynos_ufs_setup_clocks+0x8c/0xa4
 ufshcd_setup_clocks+0x1c8/0x2a0
 ufshcd_suspend+0x4c/0xa8
 ufshcd_wl_shutdown+0x88/0xd4
 device_shutdown+0x158/0x1d8
 kernel_restart_prepare+0x40/0x4c
 kernel_restart+0x20/0x88
 __do_sys_reboot+0x198/0x218

This is visible on FSD, where the CMU gates are in manual mode so
disabling core_clk really stops the clock.

Ungate in POST_CHANGE when turning clocks on and gate in PRE_CHANGE
when turning them off, so the HCI registers are only accessed while
core_clk is running.

Fixes: 91c49e7e82d7 ("scsi: ufs: ufs-exynos: Add setup_clocks callback")
Signed-off-by: Charlie Jenkins <charjenkins@tesla.com>
---
Found on a Tesla FSD board.
---
 drivers/ufs/host/ufs-exynos.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3bcbc9ebbb283..d2a79ebf193e3 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1116,11 +1116,11 @@ static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
 	if (!ufs)
 		return 0;
 
-	if (on && status == PRE_CHANGE) {
+	if (on && status == POST_CHANGE) {
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
 			exynos_ufs_disable_auto_ctrl_hcc(ufs);
 		exynos_ufs_ungate_clks(ufs);
-	} else if (!on && status == POST_CHANGE) {
+	} else if (!on && status == PRE_CHANGE) {
 		exynos_ufs_gate_clks(ufs);
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
@@ -1139,7 +1139,9 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_intr(ufs, DFES_DEF_L4_ERRS, UNIPRO_L4);
 	exynos_ufs_set_unipro_pclk_div(ufs);
 
-	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
+	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+		exynos_ufs_disable_auto_ctrl_hcc(ufs);
+	exynos_ufs_ungate_clks(ufs);
 
 	/* unipro */
 	exynos_ufs_config_unipro(ufs);

---
base-commit: e550f2b2b4aab4c5f12db89d04d8978ce4ed7b4e
change-id: 20261110-ufs_exynos_hci_order-0ea9b8035f47

Best regards,
--  
Charlie Jenkins <charjenkins@tesla.com>


