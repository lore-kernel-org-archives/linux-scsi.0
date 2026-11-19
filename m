Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101589;
	b=r/ZI7fB82KjOZEqBuVCunYGcCP0cneu7tYB8giWmCEXTg/7K22oS/+GD+wP+li9h75tr
	 LMqT/g7POHctNREGTdClfLtiXaWBpmmrLDxJLCMyrDJ/O9Zz0NSa0mdSsPsGfH684Ps07
	 mNma7cEXsXFhB1l5Aw9IyOqp1KlOEK0NYDQPV6Q2GakzIdG6hQNTIhgD/5OZSkVjqWkEn
	 GoBMik6v+eRXtd+kdSCgX7MyMPLtc+33pioH3A5e0Af542VU4OOtXl3+EFm4SnpGdE8Zw
	 Pnv+FjD2ijBJXw/tI9viHSLI+SnmWVwWpNSDAXLUz/t964lCa1WTYfu9wdjqUdYIkdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101589;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mhNRPmlGr+pai8rlonmOXJXc8xvliO1wWhsM41Vh7gw=;
	b=zKDONIbzq9nfcOHv7BzBY52wuK65WBarquf48aGr+dBKmqfKAxcG+NOGtM/xI7REtrXw
	 CG8wT1ES3ljdhN370DaioaUK4KkH8ju9Rs/YfB055kfUxP+VIKafVR11zObxcEfj6BnkH
	 n7n/5lSnaXLGD0yjH9URh5/e7GVM1U+L4balZiB+G8gou3Zd5i4no1GTie2d0nID0FDyZ
	 hfPrRFCVYdBzv4UMP3i1CvaSE1pkN1bnaye0pRJNf4rOKWWoK76Obv9XUeaARy3OWfhKx
	 s33ropQNPBemG2kY628Gh7DuANGtssMyJdvKMI0zJ+CuVLEpPCRAPpJWZEibnGFZc1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OgOUeMkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD893606A320;
	Thu, 19 Nov 2026 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OgOUeMkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068E31F000C4;
	Thu, 19 Nov 2026 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795101589;
	bh=mhNRPmlGr+pai8rlonmOXJXc8xvliO1wWhsM41Vh7gw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OgOUeMkZNLU9/QZOmKoHZEVJBSuo/t+T/kIGOIlvcACwD9fmvf6akYDv8kXX6GOvf
	 TgA3MxqTK1hk0Dppn0TmErkxKBi2kKcpLDzscp8BrkkCnoexumernGsJV/Px25dNzR
	 xthZ/6jXcdqXgXFK3J86VyIspstUag6rX9ESz5tSn0Zv4msUzit9OcxJ5wL9eCcK+J
	 L9aA9TlQ6HLM1nq7E2klhOWoMG1fdzjZHBb6pS6sNlwgGTbz9e84wGD5UQFrWi+M3h
	 yO90XYIgKzLqw8HnH48LvhUCv1QJOHNRPDMRtL3Zr06Z7EWIUe5vndf3XY0gKY0Fyl
	 2E/OwDbkkBKVQ==
Message-ID: <sashiko-outbox-223364@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 16/23] scsi: ufs: mediatek: Rework
 _ufs_mtk_clk_scale error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261119-mt8196-ufs-v15-16-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
 <20261119-mt8196-ufs-v15-16-aae1eb0382e8@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 15:19:48 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: ufs: mediatek: missing Fixes trailer for
  _ufs_mtk_clk_scale() fixes
--

commit 4421ac01b44e9c03d7a805d55558f0e6f608a409
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

> scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale error paths
>
> Errors should be printed at the correct log level. Additionally, it
> looks like some "goto out"'s were omitted in the scale up case, which
> looks like a mistake, as the scale down branch of the code does use
> them.
>
> Rework the error messages to make them nicer and at the correct
> verbosity, and add the missing gotos.
>
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collab=
ora.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[Severity: Low]
In addition to the missing goto out when clk_set_parent(clki->clk, ...)
fails during scale-up, this patch fixes a clki->clk prepare/enable leak
when clk_prepare_enable(fde_clki->clk) fails.  Both issues were introduced
by 5e5976f5242d ("scsi: ufs: host: mediatek: Support FDE (AES) clock
scaling").  Should this include:

  Fixes: 5e5976f5242d ("scsi: ufs: host: mediatek: Support FDE (AES) clock =
scaling")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-mt8196-ufs=
-v15-0-aae1eb0382e8@collabora.com?part=3D16
