Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82943D3331;
	Wed,  6 May 2026 08:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778057283; cv=pass; b=qJLknosyb968Sn2zxUBJbTHa+zstGBbCkHISt60XK2+0vOO531xc5Nqsf1bj5/Vk1Zu445ibzQ7iDcWUBwl4njEpFcFEnyB4GQWb6Di+Da5KJbEtwdv/SyuXhUqHJcIQjX6e3id2/f4O7ZEahH4sPwA5ox8Qb1Bv0n8IHOIb9K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778057283; c=relaxed/simple;
	bh=A9UjkuOfx6xitVV0YSTgLZ8+jOwyWk9cw6iGgQd/3mQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HtmPWrGHe4Nt9vGDc73TlQLM6Y3iewwkSp0lcbByw1zcJsNgemrYE1LxgYTavyQxQDGMgBDb6kkAydGGRHADm/JC2PMDGB7xhmmWTIdvtkh2iUQ4KicbPr0jOmotwN3PpE6oMVm++UvSMegO/hDT4lR2CQ9qbiCdpnl49xt00zo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=U1tRPjmw; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=lUcQ8FyD; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="U1tRPjmw";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="lUcQ8FyD"
ARC-Seal: i=1; a=rsa-sha256; t=1778057272; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=gNEntYKu3jpga6vWcuhEgSKraO0Mk2eRvZ200BeE0xlTHuXDlLGEQvwa3Ad4AUN5gb
    bSkzPRl4uhRdM1byMtV9R9rV296U+q1RGeoABNivDwX7qVzqiFPWbEy+mIlAvNq7r0U+
    aREBoCdh+yjt+YzFLNhk2Q8I93XVufGqQQxwo81WYU+Myj/XXIujlAJZDrMnXhCLD1bK
    /usdckJ7GKZwVkSywyZEWbBrPnmczt1ayJA9OuOApmGl+2ayaZ2R9gjPFMZIeBUlDzTy
    rOVcv4OozfUUne6TdiFlCcJNygJ1s1wCezzMynQGE29SK73bsJlKg6iXppsjpkkCru3D
    hVzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1778057272;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=A9UjkuOfx6xitVV0YSTgLZ8+jOwyWk9cw6iGgQd/3mQ=;
    b=CSVezVKmMLUC7QvwqISpIrQYW/dLMTradDuGoX1Pnk5zmXqregYyJKVXbJJGOvqP17
    isL97+4h/GDIvqH9iR2Y94e91zQWaPAmmKC+YibVf9ZL7qHvBi1Z7TFfNY93yE9hB9DA
    676eHsZCFIekIzHCcq6AV8FdhpJV51XxCKw733oZo7Ymprs9IL3DvUP5OSjVvIqn9veV
    O4VWOFZEF4eLKbawKjAS1SsApxgnB85B8/FtRzsSt/YQrStU8HUXmDuLiVUzM4ANNqVw
    jgd4Docm1BOpJFeOfVg0PaFxGSUASCXCc37Nj4M/gBh8T77cJImELaXnYfydeyM0tKWM
    CoNA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1778057272;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=A9UjkuOfx6xitVV0YSTgLZ8+jOwyWk9cw6iGgQd/3mQ=;
    b=U1tRPjmwYjDb755Z2PgWCSXvebCtaHVKArTRZbdZ6OpNxmI2YBkFUdCpvKtysLhdnb
    XlCFswxfSCpaPu9nRjGuc9M3wN4tuUk2DEkqFQv/XKEnC17k605p4RcUyET9TdMV6DWy
    MPRT9ce3ugr927yeJtuVunAzLzRPqItl4xccCjbk100YCpPI492hxblx/gn05Tj237Da
    z8r0NoAA+7ucNIl74zOwdNJ+UHfTunLCM2n6WvN4C4C1rL15fZzRmafOStZiIdK5vhuT
    sMzWiGdYd9DlcpjR4XS194F2P/xh4VGsAfD8Tv1BYhRhSx/WB5RTucys933ctUJFvIMp
    pUtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1778057272;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=A9UjkuOfx6xitVV0YSTgLZ8+jOwyWk9cw6iGgQd/3mQ=;
    b=lUcQ8FyD9cEU9/451pRT9dR8o5KoCPPd7AfLkBP5MOcMGCKqYWtRe+SxKTeUTsk6QL
    Q9A7Wudn7FfysgbW2PBw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zJolXNpY6H6HHnOYUA="
Received: from [10.211.8.62]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z793452468lpGAH
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 6 May 2026 10:47:51 +0200 (CEST)
Message-ID: <a349ab70dbed9355785bec38c7e05658f3c948a6.camel@iokpp.de>
Subject: Re: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
From: Bean Huo <beanhuo@iokpp.de>
To: Fang =?UTF-8?Q?Hongjie=28=E6=96=B9=E6=B4=AA=E6=9D=B0=29?=
 <hongjiefang@asrmicro.com>, "alim.akhtar@samsung.com"
 <alim.akhtar@samsung.com>,  "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>, 
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Wed, 06 May 2026 10:47:49 +0200
In-Reply-To: <67965bf50abc4300ac9bd3aced2f18d8@exch02.asrmicro.com>
References: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
	 <897db8bf4c82af97cd7bbb2b908bb9e2654b3103.camel@iokpp.de>
	 <67965bf50abc4300ac9bd3aced2f18d8@exch02.asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-06 at 03:29 +0000, Fang Hongjie(=E6=96=B9=E6=B4=AA=E6=9D=B0=
) wrote:
>=20
> > From: Bean Huo [mailto:beanhuo@iokpp.de]
> > Sent: Tuesday, May 5, 2026 2:41 PM
> > To: Fang Hongjie <hongjiefang@asrmicro.com>;
> > alim.akhtar@samsung.com; avri.altman@wdc.com; bvanassche@acm.org;
> > James.Bottomley@HansenPartnership.com; martin.petersen@oracle.com
> > Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v5] scsi: ufs: core: call hibern8 notify when hiber=
n8
> > cmd
> > failed
> >=20
> > On Sat, 2026-05-02 at 22:30 +0800, Hongjie Fang wrote:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0default:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0break;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > > diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> > > index 8563b6648976..4f7c619db324 100644
> > > --- a/include/ufs/ufshcd.h
> > > +++ b/include/ufs/ufshcd.h
> > > @@ -270,6 +270,7 @@ struct ufs_clk_info {
> > > =C2=A0enum ufs_notify_change_status {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0PRE_CHANGE,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0POST_CHANGE,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ROLLBACK_CHANGE,
> > > =C2=A0};
> > >=20
> > > =C2=A0struct ufs_pa_layer_attr {
> > > --
> > > 2.25.1
> >=20
> > Could you include the platform driver that actually handles
> > ROLLBACK_CHANGE in
> > this series? Adding=C2=A0 this new rollback_change without an usage mak=
es it hard
> > to=C2=A0 verify the design is correct.
> >=20
>=20
> The platform driver code is still under development, and we plan to submi=
t it
> in the future. The purpose of this patch is to first provide a mechanism =
that
> allows vendor callbacks perform relevant rollback when hibern8 fails.
>=20
> > Kind regards,
> > Bean
>=20
> Best.
>=20

Thanks for the explanation. However, the kernel development practice is to =
not
merge infrastructure without at least one in-tree user. Please resubmit thi=
s
patch together with your platform driver (or at least the hibern8_notify
callback that handles ROLLBACK_CHANGE) so reviewers can verify the design i=
s
correct and actually works as intended.

@Bart, any idea?

Kind Regards,
Bean
