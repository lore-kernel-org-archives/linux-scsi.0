Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795654425;
	b=qHMfgChc1ZXPMRaIpOGfgmRvSjVwEg8mFZoBWr/nWLi7y5Zd3jVQ4tH+0FBxEs3Ikm/2
	 ruZloUE82HEZX09IPKKaq7bYayp+5/oJuIJlBeC7F1nSIegPvo5FUoyNTUOGaY0lvj8WU
	 9dZMsE0QYZfFeduzIMNbPxVSplj1QPbUffXlODE4m+VyycAgGWe3Mu/N4x/lLLZITuWb9
	 THus3+4tqu3Mh8CUbC7ImMeh/pCHofqgw+jcr2WMhjbqaOJCLcT2gXMyxWiDmSRvEIKzQ
	 cbEkRwM3mNvlpEU6oUjqPZo50YEjoJ+lYyiAq6EkdNF5oULR8StNFzUQz0l3ehteUVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795654425;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=p+xXsZjiaXoOEz9qBEyk4TJitPlTvM0wfvW8yye6/+I=;
	b=irPMvil2NuJscKEKJhq0gIsivBj9U9DR8VowZNFQeUiR3iFFyjOSBh7L/dBvpj33X+9l
	 a1NVH9xw7WDv2ZroylP0qLMhXVyXdzz1kx5Ml6hpAdEaEuHdFqgVEhGzKRNu6hkBEptMW
	 pzbl/BX6yryDt3wtzFqM1ow4z3kKEH+5FxUuZs+wRAScrE0spoqYDmCyq2C2F3EyWph9n
	 uUuCgmIGYmw+KxvmBf+lfF7o0rXCqRjNqBnUXgj+UtWqai6ieQM/YKkz4LL+RhFa+R/Fp
	 mzS2OGd8nMZoFwZfmteUdi4I5Ch679q5qGSN80mRtdR67pyeDBNnJ01rSz+BZ6N/Y6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FD1oC7Of;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3745606A689;
	Thu, 26 Nov 2026 00:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FD1oC7Of
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795654424;
	b=y9EsrpbSud89XRA6b7RcJ1kyCCm+/rTEHCNBP2sUAyIxsim/1bh/REL5xbi0qbpUTVAV
	 x6NzXtBaWQK+dMPjFb5iNCgLVrWt/RrL3oIYw/pyfDM2jrMxcWdJ4arTZJZ1PE8PgQS87
	 ZKJWU8U+yxx1k5vqlULMqP5TeqVbF+vuaOs748fIQl2XnzxGPPkRpw15Zn9SJXPQ1F74S
	 cPmlK6leCCBt/h27qxi8vuT/k64seLAgFhrgaIz8yPjG19AdgLlMCHASR7v1HUyKBh9fa
	 sqJ6KlAef2vooOsCtus/6DKuJp1HcTg5F4CpfmCPstrTsG3tDdGpCvvzDao7+QyYFsw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795654424;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=p+xXsZjiaXoOEz9qBEyk4TJitPlTvM0wfvW8yye6/+I=;
	b=xKTD+ZhOOoYyMWr/cfFf3Hy4OQ/DaV1MRqld44w9x3PjgECL57VVACfbnEDhahr4TpVg
	 id5ovcvyZ/zKpJQnFQJNVNEvtEet2jzis8Bn/rjE+SW+vKHtr/SrrGHI0SPGiNeaELY22
	 A36/hNDJyF1PE/qDlgigQuyocgFGJUsXzVPSmBtvMf4A9M/KbxkFkre6vv6lTcdE7h+Cg
	 Ha3iFftJbmBDbrFLhiZEkopDojbxxGVOhG5qVWtmuh19HkzHzukgtPPFA9OtB1uYpiEVD
	 R0rLEy6NXg0VG+gXXcQF4dV9Iic364Yyurrle9GY9NiTpPSpangESF2JQUVtmGaJHPw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 224601F01805;
	Thu, 26 Nov 2026 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795654424;
	bh=p+xXsZjiaXoOEz9qBEyk4TJitPlTvM0wfvW8yye6/+I=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=FD1oC7OfpCfDcw0EAeDV+2RBkt1epTjJODIk5zoicbEezGTQLraO5DyoQRoV6z8Fm
	 B25xaAY1G3GU8UID2vxiPxEYEWVb0J1GiIAX2ERcTuORFi7nBRzQ8TnkJCVLrJfChs
	 1wVAg/LsYmWbNEU8DTeFJ4e2fWa3osb06vwKyhaMEucJc6QFMvYWmX00uLF3Jj9K7m
	 4Zi++hvdkb76obHvPMV3Me5q66pS3VHzqqwmfY8DpWtHlIhIMV+RKg3wiQrn1HLrvE
	 tkLTIENqXiKK2yYVBi3WO++dYM8V3QAaNs8IC3vuJzhYdg7l+uZAG8OY2xnfzthPRd
	 kDIRUW04lL6ww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6429F4D153;
	Thu, 26 Nov 2026 00:53:30 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] scsi: ufs: mediatek: pre-UniPro-1.8 adapt and clock
 scaling fixes
Date: Thu, 26 Nov 2026 00:53:29 +0000
Message-Id: <20261126005329.72010-1-iasnezhkov@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795654409; l=1254;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=iEJQHKPytlPgQrAMYjID34D1fho6DWUFdxsNjm1zibI=;
 b=SnyT9H1v+r+1O+qvMYQeOuPjOSqeOFEVKHzccLAm8A6DFpfvEFDNxZfCPcyiOEJMTSot9SSVh
 Nd0WFobSctWD8RzzdBXfKhq36bBM5MVBqDIPTsVEO+bOa9odDuszUog
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
   and discard negotiated power-mode parameters on every gear change.
2. Allow _ufs_mtk_clk_scale() to switch ufs_sel when the optional
   ufs_fde clock is absent, matching ufs_mtk_is_clk_scale_ready().
3. Round clki->max_freq and clki->min_freq with clk_round_rate() during
   ufs_mtk_init_clocks() (keeping clki->curr_freq synchronized and
   preserving min < max <= U32_MAX) so PLL-derived clocks whose rounded
   rate differs from the nominal DT frequency can scale back up in
   ufshcd_devfreq_target().

Found on hardware and drafted with an AI coding assistant.

Ilia Snezhkov (3):
  scsi: ufs: mediatek: skip PA_TXHSADAPTTYPE on pre-UniPro-1.8 hosts
  scsi: ufs: mediatek: allow clock scaling when ufs_fde is absent
  scsi: ufs: mediatek: round scalable clock bounds to clk_round_rate()

 drivers/ufs/host/ufs-mediatek.c | 58 +++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 13 deletions(-)

-- 
2.54.0 (Apple Git-157)



