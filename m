Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF82D1936;
	Thu,  2 Oct 2025 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759411185; cv=pass; b=ocaBXhKOuczLpEfJtWIcG0A4wvGnasmWY+5NzVYRuKDwKSz0Ak0/hpGgz+GP/XG2Ih+hmBbLZ2z3ea+tOqHd8OqI8uzwblo9bHFekBfRuR2U/Q9FWZO/QWM9j5QYoKiXqWg11gd7mqHfzBZXo6uKL7iCzSZA6Y3H+gUz5k1TZTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759411185; c=relaxed/simple;
	bh=JzvkrumKusAlTsB7Mu9S0miZ9QQmnsaq0ov2x1sE5/0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=do1F5OXnExu57mer09HvtRGdraq9/3MZGHYpq34KRbw5VJIobKlO1uGHhZMfSDUw5b7+clZH69jwa4mvA+xNBa9h737VJ/MRBvfsuePUPSbk2o3JYIT4Jh1vMBTefqpMIGtc/6o9fpmKcOEAWAdGU30tBa8J1/w15a9hxlxwXDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=A8J2E4a8; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="A8J2E4a8"
ARC-Seal: i=1; a=rsa-sha256; t=1759411177; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=rUfvcOL2ISN0pjTmN81TDa+cqt1kV8WyxaRe25xzB7xcUpTOJ1L72pWm6GLUTK2djn
    tVw+5e+NNtvPMEUkvKfvrNGANMq7Xmsa5E3pb4zqj5gCQfWmhXWxenWWb0zxx49lEo2v
    JAiJxXtAiDQhtcTTE9DvxnWRSeCjKPmfWO0STxGdr587DuX7Em9T71+crnzv1QHjWDIX
    rxT+MjW6bg3BLxSi3jHUtysaIoHdXKtIOQutBQQ2DKqNPK155p22p5tIUILcCsFwVn2A
    PXAHmeJe9RaH7e2k0e1LDEizcgeeb7RPnCFvzi5CF1dOIbLgdq9SaKtYLiyGt41q9VAR
    b9Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759411177;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=pY+LXWZai8R7ETSQISmr3YBTii1mPODyogPubFswHaM=;
    b=AmQBh1r6gk03AmXA+AlPg0MW8PS5n1OyBjZp7m8pUPcU28tYoH3vAlNg7Cu4QbVC3m
    y7l7pMOGZEu3mz1qpQsxJdCf+7lAr7ClCzk0c22rif68ZLgFW37ob57Ozd7VIzk9hDE3
    YA41VQ4rgNH2pB+mFWuDum2lwpgcvaQsUOHJZik25W+PP5T/oBw5fiTSnzu8RuItcDvK
    0Dqw5e8mIlUDkzrHjK3670roXKnCxP6xnn2uWh1ci0V1WRP+Y+dnyst4NlKfBO/1nhqa
    Y0KLhId62g0ZUsjZ01X80jPvkusAH3fGDB6B0ru3sZj2ZR6LJ2B3n0atHw4A8JT4APF+
    onIw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759411177;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=pY+LXWZai8R7ETSQISmr3YBTii1mPODyogPubFswHaM=;
    b=A8J2E4a8wt89LpysYnaIcZ2LA1cooT071iqY6t/CZ6gjwdq0I5GxzNEUc4F+0Itj0i
    Fv5hnER8pkKR7MUWESEczpGabXG9D3rFuYDM5sDjf0VHiIePrTskg17yZ2V7Xi3Bk2+w
    PpQowEOetRbxI8OtCuQKAIW2J3/XlIuOmOn2SUMkSE2PoJO/YseOdyvhdvztBaapel4U
    WbULt66gXKjwMVP347kHbcTUJF6zA7YIni6pjhg4XSiiNFuqnbvhVyM9m5yfMs2DJeFM
    OwrkoQ+tq7OMiqQZXoyguiFT4gwrbGthe+HyGj9OxKZ4OAAhNoeGcibzk+u5yjne5bhy
    qsDg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zJolXBtbIoYhB+fa1AL9w=="
Received: from [192.168.226.211]
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc6192DJafN1
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 2 Oct 2025 15:19:36 +0200 (CEST)
Message-ID: <b7a1de5c459a98935ad6f2fbdc35e1e96d1242ba.camel@iokpp.de>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <beanhuo@iokpp.de>
To: Avri Altman <Avri.Altman@sandisk.com>, "avri.altman@wdc.com"
 <avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>, 
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
 <jejb@linux.ibm.com>,  "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
 <can.guo@oss.qualcomm.com>, "ulf.hansson@linaro.org"
 <ulf.hansson@linaro.org>,  "beanhuo@micron.com" <beanhuo@micron.com>,
 "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Thu, 02 Oct 2025 15:19:33 +0200
In-Reply-To: <PH7PR16MB6196ADF912182709D465970DE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <PH7PR16MB6196ADF912182709D465970DE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-10-01 at 10:06 +0000, Avri Altman wrote:
> > From: Bean Huo <beanhuo@micron.com>
> >=20
> > This patch adds OP-TEE based RPMB support for UFS devices. This enables
> > secure RPMB operations on UFS devices through OP-TEE, providing the sam=
e
> > functionality available for eMMC devices and extending kernel-based sec=
ure
> > storage support to UFS-based systems.
> >=20
> > Benefits of OP-TEE based RPMB implementation:
> > - Eliminates dependency on userspace supplicant for RPMB access
> > - Enables early boot secure storage access (e.g., fTPM, secure UEFI
> > variables)
> > - Provides kernel-level RPMB access as soon as UFS driver is initialize=
d
> > - Removes complex initramfs dependencies and boot ordering requirements
> > - Ensures reliable and deterministic secure storage operations
> > - Supports both built-in and modular fTPM configurations
> >=20
> > Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
> > Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
>=20
> Nit: Would it make sense to simplify things, e.g. :
> Instead of struct list_head rpmbs;
> Use:
> struct ufs_rpmb_dev *rpmbs[4];

Avri,=20

yes, having a fixed-size data set, choose an array over a list when needs f=
ast,
random access to elements by index. I will address it in next version.

> Also, I don't remember if you were planning to add the additional rpmb
> operations (6 to 9) later or not.

yes, to make those usable, firstly need to enable in op-tee OS,  I will che=
ck
op-tee OS and enable in extension patch.

Kind regards,
Bean

>=20
> Thanks,
> Avri

