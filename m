Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3111E2BF000;
	Thu,  2 Oct 2025 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759412352; cv=pass; b=JRUEdj+5rVMvRNMTPbNhe+HC6jT3yC2iqTLEJEj/aVcihNlpSdV9z/Vzh3reMbhDN7LquhCbRbOgCvj3lLAbliMIDYtsvu9M/iX3gcffDFwtEwM0fE1VkRpLANfZXWth5VLC2sx1jde8MhyTKPH7AMECEKG+gX1wyKOy6rkoRng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759412352; c=relaxed/simple;
	bh=ok0oABOTAz4IqjL/jhSwhVG08CIXLzEnY/S7FooKACA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=leH8Vlky5v+u2X36V7DpT1AijduCUh3sGNcsWP9BL+DQzsnjjmb8sZ1YDtCUugBcmFfM6BUrPZt29iZQClvgSC0CWe7eACg5hXHVR/a78HJrDhqFcI2yZxD13tfysvUe/daZqk7xIofzd17wvVqVbVp1DbCATmTiVqc6DTQtn0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=U0JtkGlm; arc=pass smtp.client-ip=81.169.146.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="U0JtkGlm"
ARC-Seal: i=1; a=rsa-sha256; t=1759412341; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=pdSd5BJAS1ICTCI7us36KavG6qSzkhVtwOxCdJvWK171UA22cznORI/E4mPvCYeYsY
    KWWAF6e8bMsUhsWb//ZQe+BnVy4reLyT5y9FH8e9DXYELyMiYLVOU2jCuulcRj94o1A5
    6VD0nc5uJN/7IyMX169q2JJ99yiRLjediRm4vrpz7AAmbpvMUBxIs/JHiXwEfNcpwKuz
    e4bdu4n3+uGfux6Wg10VK8hJ1bcWlVl0/6erXd2yfLYTgFo77bYGropOlR4CH4agcCNx
    A3WeWDV23UQZtEiAG/GpVluFyVEX+gbnDmlrZEQpOgSkcx257eNreDhY8YIBsgEXHUnO
    m6bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759412341;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ok0oABOTAz4IqjL/jhSwhVG08CIXLzEnY/S7FooKACA=;
    b=Esjs3CzB9gJdsBCFjlRl1o7DpAIWMcdj+TNP7YvefiANcIzIyVx2jw0imqunqxosfn
    VRtM0+/VDAyK8JD2+FNrN042Lno1npuoRZmOyqPcBOB8osxIHQ4Az6PDBPZrrN0ycL2C
    +yDaJ+RylH6s9oC2TLqv2Uckp6l5AlfXxQa7QJxhhmVTL4Kvk8qLM4X/yx1bIIcrQL2N
    97K0/+DCWRGhD2vwpJBRMO2isE/Id2PSY8lIUg+NXElvh8WCFiKjMNmX3DBqvQ6kdtTQ
    Ifgv22K5OpyTSJilO/J8nLHAYPsxdag9+mnFIO45UwOVWND+2P7H3y6IkTlWdz4jz2mY
    97ZQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759412341;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ok0oABOTAz4IqjL/jhSwhVG08CIXLzEnY/S7FooKACA=;
    b=U0JtkGlmrp/t/CCTqMNFD/V/YkaBmboFe7DkcA0ODF8YljpYtfCAn1e5wVAkQZqU1t
    d2ZY8HCiKqE07+vT2ZNL2Q756GOaIoDhYi5O/JH+cdwLsyoN0Q5PEoz8AWANc+mGQGcU
    ijDWTJBX/3JrOAW8oYVs+qRzKG8izChIRHNuFCchuEC7c9At4mgXYKp5T3PUbFicTJ7w
    crqAOP67qDMnK0p0hKTZujRsL7vzNhYkXbhsg0bGt3v9uvAKllSNoxLjy1+O1Yi6EXCj
    bxUy6gEue+uEB5RSyDP0Vk+M9LPuaTKwWyNjBke3cfW68P/t+ijQbhCK/xG7Fdfs6NwA
    KTvg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zJolXBtbIoYhB+fa1AL9w=="
Received: from [192.168.226.211]
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc6192DcxfSZ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 2 Oct 2025 15:38:59 +0200 (CEST)
Message-ID: <a2aeae41e7ebcb56f339e563d21a676d0f44c23f.camel@iokpp.de>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <beanhuo@iokpp.de>
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com, 
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2025 15:38:57 +0200
In-Reply-To: <00a30e2e-a137-4365-9478-91ecbabf07e7@acm.org>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <00a30e2e-a137-4365-9478-91ecbabf07e7@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-10-01 at 12:51 -0700, Bart Van Assche wrote:
> On 9/30/25 11:08 PM, Bean Huo wrote:
> > +MODULE_DESCRIPTION("OP-TEE RPMB subsystem based UFS RPMB driver");
>=20
> Hmm ... "OP-TEE UFS RPMB driver" is probably more clear and still
> unambiguous. Anyway:

Bart,

ok, I will change to it in next version.

Kind regards,
Bean

