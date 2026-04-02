Received: from iad-out-010.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-010.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.197.254.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D15F3E51D1;
	Thu,  2 Apr 2026 12:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.197.254.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775133130; cv=none; b=gUAmpfk9F9uxAl1+/eRI1fe1DYgsRPBu6avXygg1fbGO+1rsBjwWueZl7c9bVaGL0xaySvUdX9C/w4Eb22xgelnyYn73QH/JJxVcNnA2DnBBLxDPlMW3CW6v2LmEtrHqq78gXdc1d0bFEq6FAszQ+xZzpQRXv4JiCqGVso5744c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775133130; c=relaxed/simple;
	bh=aDYtmSvd0EEN3gRzBnxf/nlkESwF4ea02ohRXl6ElJc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KqC3rvJqECPr4IDyxfz0a9lkSGyq37WnYLdWOgxPBmpGXVprkUc580ff3E0O5nDCCyF/8Tn5+qfxZheXYSLXuL0H/lgSHU8IOFCHmmOw4dXXVxAIFnsT6s+7K5VaYH/nWIr6aVLsavLqQa2x+6qXd1AQ+lk43osHH1n7eFPGt14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=TLJNze09; arc=none smtp.client-ip=34.197.254.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="TLJNze09"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775133125; x=1806669125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=6w3HUVHSmjm01LKzbzqMd/c0WGfyb9c7ge6p63vHYQI=;
  b=TLJNze09s90omXNwh/EVneUqNcRFVos12lrBVwuckpj9mjeoIw8krJk5
   0ggvx4lKPUQ5Q9HDmfTRZpfkfAvpzX2r8rDa78d85sZsjASqwS1pCvYoE
   SBXeygTpvn2Qbqe1NCC30sBzasFu4OKifydxG+NuwiXsVT2MLDmvTZD08
   4xBKFyoYPsLjnwHwo289oFCga7x65r3Fh6r02wkgIU35FOfhFQipxvnjQ
   wmsQZdB4f30IKsOyAnpdw2Y9tZs6XTWbImWxuhOF8zrRdaUVTpv5P31LM
   khAR66KtXQiVA/KkSfAolQHHgqW3G24AZYDak4oAX6nqdnw1V/ctpoO/t
   g==;
X-CSE-ConnectionGUID: DdekA+7kT0eMkTYJA1rRng==
X-CSE-MsgGUID: /6glz+8BSwe83yXe9ZoY8A==
X-IronPort-AV: E=Sophos;i="6.23,155,1770595200"; 
   d="scan'208";a="15095409"
Received: from ip-10-4-10-75.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.10.75])
  by internal-iad-out-010.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 12:32:00 +0000
Received: from EX19MTAUEC002.ant.amazon.com [72.21.196.66:23526]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.8.197:2525] with esmtp (Farcaster)
 id aa9e9018-8b88-44d4-9916-7172c14268fc; Thu, 2 Apr 2026 12:32:00 +0000 (UTC)
X-Farcaster-Flow-ID: aa9e9018-8b88-44d4-9916-7172c14268fc
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 12:32:00 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC003.ant.amazon.com (10.252.135.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 12:31:59 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Thu, 2 Apr 2026 12:31:59 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: Fedor Pchelkin <pchelkin@ispras.ru>
CC: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Sven Peter
	<sven@svenpeter.dev>, Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch
	<kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Hector Martin
	<marcan@marcan.st>, Alyssa Rosenzweig <alyssa@rosenzweig.io>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, "Avri
 Altman" <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "Sasha
 Levin" <sashal@kernel.org>, Peter Wang <peter.wang@mediatek.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Seunghui Lee
	<sh043.lee@samsung.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>, Wonkon Kim
	<wkon.kim@samsung.com>, Brian Kao <powenkao@google.com>, Hannes Reinecke
	<hare@suse.de>, Ming Lei <ming.lei@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6.1.y 5/8] nvme-apple: remove an extra queue reference
Thread-Topic: [PATCH 6.1.y 5/8] nvme-apple: remove an extra queue reference
Thread-Index: AQHcwpyzTCv4ZXIhp0SsQfFW9ZSeHw==
Date: Thu, 2 Apr 2026 12:31:59 +0000
Message-ID: <20260402-anti-cuba-1ea02cea@mheyne-amazon>
References: <20260401-pliny-ashley-ff03a0b6@mheyne-amazon>
 <20260401232116-53765a086f3855a30962fb81-pchelkin@ispras>
In-Reply-To: <20260401232116-53765a086f3855a30962fb81-pchelkin@ispras>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <772100EB31401D4090226323D02A6503@amazon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 01, 2026 at 11:45:57PM +0300, Fedor Pchelkin wrote:
> Hello,
> =

> "Heyne, Maximilian" <mheyne@amazon.de> wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > =

> > [ Upstream commit 941f7298c70c7668416e7845fa76eb72c07d966b ]
> > =

> > Now that blk_mq_destroy_queue does not release the queue reference, the=
re
> > is no need for a second admin queue reference to be held by the
> > apple_nvme structure.
> =

> This patch is probably buggy in upstream.  It removes extra reference
> ->get, but doesn't remove the corresponding ->put which is located
> inside apple_nvme_free_ctrl().

Now I'm seeing this as well. Has the same problem as the pci driver in
6.1 where blk_put_queue is called from nvme_free_ctrl() and again from
apple_nvme_free_ctrl(). Thank you for catching this. I don't have the
hardware to test this.

Are you going to send a fix upstream? It's looks to be broken on master,
too.

> =

> I'm reporting here currently just for the heads up - was looking at the
> same nvme regression problem at 6.1.y, found this thread, and the
> nvme-apple changes appeared suspicious.
> =

> nvme-apple patch is not required to fix the regression (this also holds
> true for [PATCH 6.1.y 3/8] scsi: remove an extra queue reference).  Maybe
> they shouldn't go to stable.

I think, I'll send a v2 of the patch set without these 2 patches. It's
probably easier for Greg to apply.

> =

> That said, the other part of the backport series FWIW looks good to me,
> and I've also verified it resolves the 6.1.y regression.

You may leave a Tested-by if you want ;-)

> =

> Thanks.
> =

> > =

> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> > Reviewed-by: Sven Peter <sven@svenpeter.dev>
> > Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> > Reviewed-by: Keith Busch <kbusch@kernel.org>
> > Link: https://lore.kernel.org/r/20221018135720.670094-5-hch@lst.de
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
> > ---
> >  drivers/nvme/host/apple.c | 9 ---------
> >  1 file changed, 9 deletions(-)
> > =

> > diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
> > index c5fc293c22123..c84ebfcfdeb88 100644
> > --- a/drivers/nvme/host/apple.c
> > +++ b/drivers/nvme/host/apple.c
> > @@ -1507,15 +1507,6 @@ static int apple_nvme_probe(struct platform_devi=
ce *pdev)
> >  		goto put_dev;
> >  	}
> >  =

> > -	if (!blk_get_queue(anv->ctrl.admin_q)) {
> > -		nvme_start_admin_queue(&anv->ctrl);
> > -		blk_mq_destroy_queue(anv->ctrl.admin_q);
> > -		blk_put_queue(anv->ctrl.admin_q);
> > -		anv->ctrl.admin_q =3D NULL;
> > -		ret =3D -ENODEV;
> > -		goto put_dev;
> > -	}
> > -
> >  	nvme_reset_ctrl(&anv->ctrl);
> >  	async_schedule(apple_nvme_async_probe, anv);
> >  =

> > -- =

> > 2.50.1



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

