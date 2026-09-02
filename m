Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933F9476055;
	Wed,  2 Sep 2026 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369440; cv=none; b=RWTKLSlGaBIIAeDzR1xn5pc4l2OcbgGKV4Ei+SZcNmiqSEpYX05TEenc/RnBR9fOK2lKrvi1zIRdXxS8cqKu1vyl5P/VGHyIR8sFt4EsNuh0m2CbhnoYFoYVkn66SjOFwkkN4QSOrr3UWlppZZuGLqTacNM4jypIFuNUoxT//Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369440; c=relaxed/simple;
	bh=o2Mv7WRrpwA7jgMetkVKrbR3crOX5CzXQPI21Zi2wMM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oRCEq27BRE7qkqCyKPdIAjnt9bmZWnD4Wd5BJDRqZmy2HQt1piPy0BQrnvt6cmWkQ6pS+xtM8gn0D9hudPgKa+W36vcSf2q/6uXZtu2xA7pPgJGtfUr0ZAXVhjgQokVLiUaVoM8b6YhgP03FX57QsPRKs5L+63oO6XMtLjO692c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OW9JwkVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OW9JwkVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010FE1F000E9;
	Wed,  2 Sep 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369439;
	bh=o2Mv7WRrpwA7jgMetkVKrbR3crOX5CzXQPI21Zi2wMM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OW9JwkVPNE3PyDLTKkEJueitferbFrJtrSCD/+Scydlci/lDUSgw0RwmGNosra2lv
	 VSlvjBbpPKf5EyXkclq6l4erX5492OcUdx/DijX5YRXsQk0Zdgf6qG3AauvnxLMSiE
	 FAkPDr2xWbyyl2u08pBh6hrrC+UDOdjLVRWNCSzyKEVzoiaH7ghpkTaczqjxH4roNo
	 grbPNZQzY6+zIHhVAjV77Y8/t3GeMwAWJmS9crpPkpmtrMugDcgIl2g+JfmDvZir5V
	 Xh/lcl9WsWBBs0x5OJ8sF3k2Gs6G1ngZMNPPB0wieFaxLau+tlYn4pGHN64MRYSTMj
	 c7gvCegsYql6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/9] PCI: Link a virtual function to its physical
 function
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260902170734.95504-8-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-8-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:17:18 +0000
Message-Id: <20260902171719.010FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> With a PCI virtual function having the same bus for its parent
> as the physical function it is associated with, there is no
> explicit dependency between the two in the device tree. With
> async shutdown, this can result in the PF being shutdown before the
> VF has an opportunity to shutdown.
>=20
> Link the VF as a consumer of the PF to note its dependency and
> ensure clean shutdown ordering.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D7

