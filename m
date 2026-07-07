Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1C342314C;
	Tue,  7 Jul 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433542; cv=none; b=RF9Cnwu+c51M9A2utHjbBmqTK9xp/MlC+pRf3R9xB7BYf/YNd675SyrVsACCb/hYJFLwmGvqGk6CAHhQYgdWaK4lej1Gu5YTv2cO9GUJ5Zsgz7twxSP5YN/Ml8P9pe8BO0erfa61XKBBaNA7Oh2Y8lOrBeRanGWnBaOfmVa0MYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433542; c=relaxed/simple;
	bh=JaAsxZ0w+6FbKXHYOtQ6Zt3r+z5zehFaKgeTt6e2VVw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C6xd245Cf/qn2qK6cSqW5hBi4lj0DakZM3oN9O+dVcD1Ace6RSBBM4zPjQ3MVnavlrLLjpoBddOvJA47dc50kc/EiyrmiD/B0diRr5yvR3FiUAZAROfxBgO6GHpPxN4wpxZtHvXGwl9hjLNcYnNE7OsMMN7NQdjx68YFqsfYbW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TewwNPY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TewwNPY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0A41F00A3A;
	Tue,  7 Jul 2026 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433539;
	bh=JaAsxZ0w+6FbKXHYOtQ6Zt3r+z5zehFaKgeTt6e2VVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TewwNPY14PciRmEI0Gx/NdBliMZpdm9etVFCe9yNlbZA0F/ki263fwTIAFhBCMDgX
	 h0IBvfkhc24yHUyB44b5swNsxw2UBC2YaHZk43rFA8iKFBV0gsLu8DRiHZBrB/RXaF
	 Eq3wGbPB7Y+bVGEIuvpCv5ia48xXZLViC655TZV1LAw7XV7GxnEyu/BnBpN1qS7fiB
	 +w2L/hPMoLN1uqUFhDWxCWgiQ888Ys7m+fVGOO4DV3azMsdvgEx6SMtd+XFL3XQek/
	 NZeQgkbl9A99rudCDcjYpEmK8sGxbGZXnr4WjyBpxVz+R7YrmN6f6WWXnOSpaNxK+e
	 apfPwDXrilSlA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/9] pci: make pci_match_one_device match on ID
 instead of device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-pci@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org, cassel@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-7-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-7-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:18 +0000
Message-Id: <20260707141218.9C0A41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> There is a need to match just IDs instead of against devices. Thus rename
> this function to pci_match_one_id, and add a pci_id_from_device helper to
> make it easy to convert users.
>=20
> Similar convert pci_match_id to do_pci_match_id, however the existing API
> is kept due to quite a few users.
>=20
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D7

