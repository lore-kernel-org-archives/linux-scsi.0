Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02E01946DA;
	Wed,  6 May 2026 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778071446; cv=pass; b=tHI3WLT4/21YcNdjk0oRH3WbUFSg+PB6QJ6pytg8mYU6FeEsH8zxjnNLOmm30KS/DABZlW7jdrzyUJZ41S5bKCiH59UuzkDyDTLqm2VJWhUA169RPSn6VKxqzNQeDA0k/0iIxc9jyMlKrnVMVfHTEKYwRnjccbVpLMIYX3uahqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778071446; c=relaxed/simple;
	bh=M9hG0SolHiM2//e1YPrvoNCbfb7Cr0FPaYDJCmgh+c8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z91aW11DmCeL9fmFvfnQAh9cVzDn8ZJnZRhdtZrG6Y24rVJic/xDE8htq3grV30PANp6N0hi41NtMXwro9R3wPshTpiB0j5XxmPpvI3iSbkmo8+5/xotwdygmGjuTBYUcLSphuu7eks4Ovj4Uis8b8ATcoua9LVwpmJprTHEOiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=eDz6ZzG4; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=x2CqYp8J; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="eDz6ZzG4";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="x2CqYp8J"
ARC-Seal: i=1; a=rsa-sha256; t=1778071437; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kDF64nHu88UWcnKD5R/UqVmo88s5wJkCedkyGUMuxPcYcFtaJPqUXK+4vaJxg8+J4I
    5TT6ICDlQSmD4VpPdo9bvorVa17+98u8AwxA/OiZPoPqtFr0JkUa5yMHbzWrr6qSBK8L
    IN+rfyI8m9EwP4E70XsG/cAC04H5PJONHIG3BTERDcxb2C8Yzoy9P11R9KqAXFVluW2O
    pF1z7/EunJmNVDP4zzVNNK9Hm4v7/zXIFkUL8x0y51RzHZZuDdOAERDa1rooQlgMvapq
    na13IgqdjKGatd7kVkopRs7BPSjdNycgaVMyymhcLQgB31VUevfrtmMuCti4JYLdkONr
    Q7jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1778071437;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=M9hG0SolHiM2//e1YPrvoNCbfb7Cr0FPaYDJCmgh+c8=;
    b=MW7A+bqh4S4cWbsaT8PP1qgudAwM741RSHsPSVH5Dy4UjqzurYgLvIamIVPC+vvw1Y
    FDJspfv7vMBv1pa5dNQhA/Mb4RQi/jkmbm5aCY//xwxJRzbrdJs+8lF6ECL1lWPqDl6X
    OlfpVlJZd7VCtRnuLSOO2dKOlmMk0YYqkszLV1ZhjEX/uXtQ0Jp/WWZr2apAr2UA+EPQ
    Ypwn9w7M756d6SOR8vVaAnRlDedyUMOqdV1PLRirHUD90rznb04Ym8o1SxfhqJMFYe9S
    /nb7Vk+dcbdCdldjq4B1cPxFB82kRln88XkSbzY9grReB2YJtYVqN52hMQiKaQtQMhw+
    tiyA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1778071437;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=M9hG0SolHiM2//e1YPrvoNCbfb7Cr0FPaYDJCmgh+c8=;
    b=eDz6ZzG4FdqMCBjn3hkkopV41/rYtgddxZXNawwwseKTyCCcQ3uw/Dks1LHqzsofpM
    tY4FJ7Zu6Hue4eBAsa2x6dUBFK/m/yVU7Y5KcF69jP5TZCZstYNCQAGJoiPW440w0hP3
    HySL3oZVXR4ZK6m7EACNxT6lyxY3nWzDYJuFBZS7Vj8YO+moo3/KJVWnFdfCOpTj9ldz
    o4r2qF4uH0vkjcbdyi1mMuDYbgSJVXhvmXwOkDkfNpKzCNBBehv+FqmZFtLYG6ZXMVRq
    ph+GS4NZ8CilJFOo90ExDA8k3KXclpCtBDLtZMWeeXioJv5rL2wTioTL7L7mvP+298J0
    /Iow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1778071437;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=M9hG0SolHiM2//e1YPrvoNCbfb7Cr0FPaYDJCmgh+c8=;
    b=x2CqYp8Jzli9+KXf7A+NicOxKgXr4qnAo82X5kZo9VGI6OdW5gVlM3oHpDVwuYPEkN
    Be37KaA5kR3wUmw6sNCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zJolXNpY6H6HHnOYUA="
Received: from [10.211.8.242]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z79345246ChvHbQ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 6 May 2026 14:43:57 +0200 (CEST)
Message-ID: <28d21b7e89f72aec8962aec75a6cddb5f8a2b714.camel@iokpp.de>
Subject: Re: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
From: Bean Huo <beanhuo@iokpp.de>
To: Bart Van Assche <bvanassche@acm.org>, Fang
 =?UTF-8?Q?Hongjie=28=E6=96=B9=E6=B4=AA=E6=9D=B0=29?=
 <hongjiefang@asrmicro.com>, "alim.akhtar@samsung.com"
 <alim.akhtar@samsung.com>,  "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, can.guo@oss.qualcomm.com
Date: Wed, 06 May 2026 14:43:56 +0200
In-Reply-To: <619d81fe-1db1-41b6-b9b2-a2546a030881@acm.org>
References: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
	 <897db8bf4c82af97cd7bbb2b908bb9e2654b3103.camel@iokpp.de>
	 <67965bf50abc4300ac9bd3aced2f18d8@exch02.asrmicro.com>
	 <a349ab70dbed9355785bec38c7e05658f3c948a6.camel@iokpp.de>
	 <619d81fe-1db1-41b6-b9b2-a2546a030881@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-06 at 11:16 +0200, Bart Van Assche wrote:
> On 5/6/26 10:47 AM, Bean Huo wrote:
> > Thanks for the explanation. However, the kernel development practice is=
 to
> > not
> > merge infrastructure without at least one in-tree user. Please resubmit=
 this
> > patch together with your platform driver (or at least the hibern8_notif=
y
> > callback that handles ROLLBACK_CHANGE) so reviewers can verify the desi=
gn is
> > correct and actually works as intended.
> >=20
> > @Bart, any idea?
>=20
> Everyone who works on Android smartphones has to deal with the following:
> - The upstream-first policy.
> - Not disclosing any aspect of the phone under development until it has
> =C2=A0=C2=A0 been announced publicly.
>=20
> Typically two years elapse between the start of testing kernel code for
> a new phone and public announcement. Another 1 - 4 years elapse after
> a phone has been announced until all kernel code for a smartphone is
> upstream. Insisting on not merging any code upstream until a user for
> the code is upstream makes the job of smartphone kernel developers
> harder than necessary.
>=20
> This is why I'm fine with deviating from the rule explained in your
> email for small changes.
>=20
> Thanks,
>=20
> Bart.


Thanks Bart.


@Fang Hongjie,=20

I respect the practical constraints Bart described, but my concern is about
design validation, not disclosure. Could you at least show a minimal
hibern8_notify handler that uses ROLLBACK_CHANGE?=C2=A0

It doesn't need to be the full platform driver, just enough to demonstrate =
what
"rollback" means concretely (e.g., undo clock gating, restore PHY state, et=
c.).
Without that, we're merging an API whose semantics are unverifiable.

Especially, other vendors (SS, Qcom, MTK, etc.) should be able to see the
direction and understand whether they also need to handle ROLLBACK_CHANGE i=
n
their own hibern8_notify callbacks.

Otherwise, please include this patch as part of your platform driver patch
series when you submit it, so reviewers can evaluate the infrastructure and=
 its
consumer together.

Kind Regards,
Bean
