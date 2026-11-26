Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795662623;
	b=N9qJ9BuxOA9PqdIREm1lZVVSJcDlXi81pbT24q1tbQOBNypWEJ1j0jNJOIBPsapyepWS
	 7C+NtBpdrTR5zlzTXZCEZiTFtuEM3WeDdHBziYP9e72FwSU+v7BZqKFVRslsMxV+UKmQB
	 UCVTeZsiStTPnkRz8RtVME0UiWqDr0338fQX2HQ4L3Ee7tepf9EMnXp60DxtYvpz5V/OO
	 uEN5+ObaxfeBoNqlbt5Jp61OasoA1amK8oRM+HKTTk9k8L/Mec1DtT+8CnlpGWFcGGw9p
	 SmpRm81YaJONDHGjWrKeV+nKM5O6O0d3T7itdi4P1m5HfGTkwajjF1oej2d5tdyrW4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795662623;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Bg/82IN4Wy87wOHHZSyJO4FokdznUSuBCgBZuEyTglo=;
	b=x31UJOoE1eYaALsbGILhcPwC7u2xiaU5jTFXz+vxEG/aKEKSMf4t/ISfJGMxZDSwxayu
	 5OLIn8H0F21iiiq/YElHja8KMuxQZFlw/9jd1v9xcSKeTAwLG1UIku8hO/mvEK8YKAtFm
	 Y5LCVAUd3hqDK9HabV829ctXJAWTBd1hyRdm7KaMbBjXzYJL0F87JLBnn08RpLNO8cGPm
	 1oyCd/IjhOc6BSImh2sGIhnGZsQSpqPXdqWGHKX1Vql+wfcnGjTiZFVEyOBS5fcZWaMGS
	 4UoBEL5EL/71jacbUMT7jiBqEhwjuexP+GzX3Fvoydijv9afbe2Y55+lNhmIfqnVP0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hxaNfQAp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F89F606A329;
	Thu, 26 Nov 2026 03:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hxaNfQAp
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795662622;
	b=zxuzlPLdkrZMu0H6eNNh/QUsy8q+jRP6uhpcAj/ZxG4PJ4l3zxhiPA80aTe5q32zwxH0
	 fSKA5QY9kChnvli6GzToJtbzxuHQWjwHMmruRkqYFawibp/GJx6kau2+8rygfKWKyT/He
	 H07wYP/GvjQxUBqmFwA430duJ8zm09Z5gZBbHwwfbr8BZ8aL2Wvwyqvz7sG2M432gQfMN
	 wmDl6oIL5l3ZM3Tg2RYnWqgdx4Xo2oQJ6hl1CAVE1iOVPwPu8o9Ky+TfE/PLLxI+ncLBh
	 QJuez0YQtlZ1T9Qb6jiXgrBbHP32eqDQuVUlyBJtPRjKRmvwaScTc2mJbAi+8HcHtYQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795662622;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Bg/82IN4Wy87wOHHZSyJO4FokdznUSuBCgBZuEyTglo=;
	b=Qdx9hE/XN9L5n4hInv0f1UeOQZtFq8WpHZxT9M+7n0N0cIe5O8SYgQ6+MCrqdJEsY9BU
	 Sdnm0m8W+KFgKpDrGzvUHFrkjgnEp5W7STjndWaf/YckvJv8TdLfcDb9W4EEMwUfwGnNZ
	 rqqgPHUbppeQYV+2l5M6IakKJqn0bisno4d2yFSO8bvmJesrVhE+F2RTyz4SNDoYHp0Kh
	 Jo3s1HV/M2nD8L5qMMwXDkgWUddbEJsWIuvQL81ZpljKWN+66J2pGlJ5O/n0RHE7kSQ6v
	 Jcg9O5kJKwcqwy2w81y5oj7j94S4F1WYKJHSc8mfGUs0q/u6Lfq9ehPhyFI0AXV1v2w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EDA221F000E1;
	Thu, 26 Nov 2026 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795662622;
	bh=Bg/82IN4Wy87wOHHZSyJO4FokdznUSuBCgBZuEyTglo=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=hxaNfQApg25Q3JPTU6Ev9V4az6aGqvdCs0ciMn+DlKmO7RBYZm6dwQVEacJAhAzci
	 CpnHGsPbPs3N93N7I1sD4OsJPrTRbSACx/ExLjzfZNxa0orsHQlwrW2wNzwrgpRh3q
	 ejDDTgAGL59HbkUspDgDGBO0ckO7BdLHj/sESnhK0Ctxc9HmjSp7RWBTKp+00QXvP3
	 brVlhaqrkH7PnvCjD5ulr/po4wiuzsvCzUB3hv69jBkRLsGDGhxumJCAyVn4x0zpVv
	 eb37kvKeSBQ92mL/WJJ6m6lryS7T8EMSsrp7/eLHReXcJuu8SQYC5pzIhmWRip4GjT
	 6xro3ngpr48Xg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7F39F4D1D9;
	Thu, 26 Nov 2026 03:10:09 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] scsi: ufs: mediatek: pre-UniPro-1.8 adapt and clock
 scaling fixes
Date: Thu, 26 Nov 2026 03:10:08 +0000
Message-Id: <20261126031008.27506-1-iasnezhkov@gmail.com>
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
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795662608; l=1580;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=BP06CLJVlJGdEHSpJcnNEfsWqrVwVf9F4B3gDHXexkk=;
 b=SOfVrfsX0so2wDlCf+TkdENLwrZyjD50wLxT6xdQB9Ovl06EZ84fiR2Y41EcTjnkOn218D1FZ
 iQSybmFGuTCCrcJ4DRGcFE34imQJlfBhGdO0Ba4PepOGZVehCGmH9n6
X-Developer-Key: i=iasnezhkov@gmail.com; a=ed25519;
 pk=hQgXfiWi4ukk2jh4BHu1vRVhg9BUivo//AFp50AKMag=
X-Endpoint-Received: by B4 Relay for iasnezhkov@gmail.com/mindone2026 with
 auth_id=1643
X-Original-From: Ilia Snezhkov <iasnezhkov@gmail.com>
Reply-To: iasnezhkov@gmail.com

This series fixes three bugs in the MediaTek UFS host driver observed on
MT6789 (UFS 2.2, pre-UniPro-1.8, HS-G3 rate B, no ufs_fde clock):

1. Skip ufshcd_dme_configure_adapt() when host->hw_ver.major < 3 so
   pre-UniPro-1.8 hosts do not fail DME-SET on PA_TXHSADAPTTYPE (0x15d4)
   on every power-mode change.
2. Allow _ufs_mtk_clk_scale() to switch ufs_sel when the optional
   ufs_fde clock is absent, matching ufs_mtk_is_clk_scale_ready().
3. Round clki->max_freq and clki->min_freq with clk_round_rate() during
   ufs_mtk_init_clocks() so PLL-derived clocks whose rounded rate
   differs from the nominal DT frequency can scale back up in
   ufshcd_devfreq_target().

Changes since v1:
- Patch 1: corrected Fixes tag to 7212d624f863 ("scsi: ufs: host:
  mediatek: Fix PWM mode switch issue") and clarified mainline behavior
  after d3eba21c7170 vs older stable kernels.
- Patch 3: use IS_ERR_OR_NULL(clki->clk) and cast max_rounded to u64
  before comparing with U32_MAX to avoid 32-bit -Wtype-limits warnings.
- Moved AI assistant disclosure out of commit logs (below --- and in
  this cover letter).

Found on hardware and drafted with an AI coding assistant.

Ilia Snezhkov (3):
  scsi: ufs: mediatek: skip PA_TXHSADAPTTYPE on pre-UniPro-1.8 hosts
  scsi: ufs: mediatek: allow clock scaling when ufs_fde is absent
  scsi: ufs: mediatek: round scalable clock bounds to clk_round_rate()

 drivers/ufs/host/ufs-mediatek.c | 58 +++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 13 deletions(-)

-- 
2.54.0 (Apple Git-157)


