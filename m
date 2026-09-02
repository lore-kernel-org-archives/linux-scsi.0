Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148304A9D56;
	Wed,  2 Sep 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370016; cv=none; b=SBmR10s23PQmdibxlWCPjDWNSuSlzaMf3Nw89Zlg3lGqlXrNuwoSFsyr+xy3l0MabSKdtq2dhPjX/GmjgajE4booQAnUmLAkK1vbeSF1gbBZ58RB249AP6meD4A7rjZ2CCJDv1rMr5cQChEbuYSfcnlNx7uT2dzcykwwrpSOjs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370016; c=relaxed/simple;
	bh=2Titb9EJ+juJdzlTYUi7QsHJbQljekvjoACvaaB0PaY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A0JsuXcPvPSnHuzeEh/TnrYFNoJzPzjat1EofYXtblvIM+ncLva2d444sufpKh63ZbnH6VJpXaVnfG1XzYJxhfeLJOUIpES6dI+pmnHuv9WLU0lVQv0UrB7zYo2akT1hMtfE2AF899KxCDvoAiwdHw+JXbM/D34g7QnGEUOt4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7DwEaCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7DwEaCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5541F000E9;
	Wed,  2 Sep 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788370014;
	bh=2Titb9EJ+juJdzlTYUi7QsHJbQljekvjoACvaaB0PaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P7DwEaCUOPh3lA+YMIpvcfX/1LFh07vxQNo1ARQl87U52B3EbuvqQSd9PTXexIjUd
	 +oY8+03a6DOyFryBQMC4vth003hU0zgLgRqNFsgsRDtil9rpWQzTet7VFiWEsF/i3K
	 B0J7HJzBhyOHA58PHC6jP9h/LyDMlTKMZvCOKx/Z8BFcKvSeKZgNEipfYbw51N4AFV
	 Cxc6XLWT91fl28lJ5dD0Vex0oTt6vy2lEh3WpUYKddmYp64Jr/wZbgjp/xWM/Bc0hL
	 LbpJjkS0jBlK5sl9oULvPqTnR18mP5U//ffla58RrLtKHc8aZeqolKFxrGKmjKuoLr
	 RVpPemPFNhOmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] scsi: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260902170734.95504-10-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-10-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:26:54 +0000
Message-Id: <20260902172654.8A5541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D9

