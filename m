Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE699383310;
	Tue,  7 Jul 2026 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433542; cv=none; b=BYyFxqGzZMRE2ZB6JUO/AqgQGU+siovPIPeNjn0h2qGZdsd7Y7Brx02Wgvz4Rx7WOYfl9tD906qem6oMZRNW06M0VqssVPBGivwRz4GQg+rISX8Vw1SJ3TXbNC5dVV9uTqF8DcqJTKDMXJ0JlfoKTJdpV99OdwwdPNxenvekTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433542; c=relaxed/simple;
	bh=eyDgeJF51paQKpDoILd8CGhbNI4Uaxh0TsSiULTfk8w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=shtq3Tfc8KdjuUwfOxe/DX8s+3x55itlexs2rNTlZzWRb/PrcVmZkCsFbx631RkrlMuPXNDRFctQO9UWOD2I2v/g6rYLCCun2KZeMteW47JQMEFVTRrzHYMiV7/iHbrSnLkEPCWb9DsM6xx2nGJSKEqjmUSx5YkOqYilToqUicI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erjAGEwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erjAGEwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3991F00AC4;
	Tue,  7 Jul 2026 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433536;
	bh=eyDgeJF51paQKpDoILd8CGhbNI4Uaxh0TsSiULTfk8w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=erjAGEwiejadxQ7ohbGW/96YMylj6W/A2WCbZ6MXSH9f836pRgXyv3aymOsKTfVsi
	 KeaMvO3G+cIQpu0lwfPvatqtzVIqqfurk7wHMs5kYOavLU7lv1SJ54GaDmYI+oirq+
	 NQVIjHhMKr6iH4jN3wvMepxe2dDIhkRhkmLBbBhlvXy1QsRNd26XEKTXTkKCFwXN6N
	 piL4fZ4ebmJGA4DqmXwn48Bcvl6Rsu8FZ1gyKXpJlRRMSGJfDY1Z7mZdY++EWx/hZg
	 Sn+uHMjtbDbK1ZypURU5O1K8CSaDK577IZbETbvzd2D38+CaA+8Eb/Qd9rF9QS3pvs
	 KvdZsSes8qs5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/9] mlxsw: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: dri-devel@lists.freedesktop.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-4-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-4-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:15 +0000
Message-Id: <20260707141215.BA3991F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>=20
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D4

