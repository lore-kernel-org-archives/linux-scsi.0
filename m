Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C83200DE;
	Wed,  7 Feb 2024 07:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707292217; cv=none; b=QONNy727BQY0Dvh8gZqDVYslxWK5vMXgVLY5TjDIa7XQ65VZDpGby862nmFsssP4YOo6FntnYuRbNG/tI+3q+Id4mzFHzDht/nGmFkWN7/KT3zN+MSvWuEiW9Ffid3e+/EhFLrqJCaDeFiMCTTptcO+tzIS962mubDjxaXUlPCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707292217; c=relaxed/simple;
	bh=bOp++vcLxzny+/Z/daxG1yKuYJV6bTM9H1oeGd5ARpw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zj8qL6QSdpbvoaSD0Q9mQ645d9f45lHfYGhbCVAcjHE5HftqkIaV61aXFMSWun1s38ugItN3sEAXQegbP46U2i1gg7lG46YQmNu2/R6sheCoBLd5j18A+fyTigrV2ZBfx8ypBDs9vgcK9DFykMVnYaOnTkU9QTFrmieyM3VNT+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=RVIgVk1O; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=jFTcK4nO; arc=none smtp.client-ip=89.207.88.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="RVIgVk1O";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="jFTcK4nO"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 969DBC0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1707292209; bh=ThX0ks0RKlAg/SPjpEdXZEyVDzASAJYtlkwhrfEU0sA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=RVIgVk1Ou0014nsfdrpmN1MinXI8MQlIDxGST0/9TpuH/bOIioNyc05Ro7xvYcFA2
	 tTBkiyLkZigfUfc4yN/6Z4ZpLdiN0qpnrw7Lfv4Iw4myO1Fs2rHuD1LEjWpOU52rjY
	 2ilaRk2RNb+C6k0buU0UZt+TVCIl0uuW5Evyo7vZ9VYx5F6+8EDFMYII76nFjwZh1y
	 JKDf2lOIAQFNgqCbjuZT9sASo0XS5tT7ErzDNdh5ntf8dR5ytV+eDFFnpDJrdhsyi+
	 5cA3uAFx5bYWJ9OLOsjLhecX7n9XUNGiIfEnIU5vevW7s6wwSDIQNSFVdIxL96K6M4
	 R4j4+2Ta65N4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1707292209; bh=ThX0ks0RKlAg/SPjpEdXZEyVDzASAJYtlkwhrfEU0sA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=jFTcK4nOHPurx/cs2vZ8ku4D7Nv9twhWwciU02vl4+7Xyl+lw4p04h4C0+K98KUBc
	 3Iii6AgwiX2UOJOZA4V/UeO+jk+knYATvl9sjOkrtddyS4X9ul0S9n4Gci0lQq1C4m
	 biqm0qdV2uUQbx0+LQAg2t+hbLelK3roOdO3h2XXYPIhU+Dwafo5m6+quEh4Cc7Rv9
	 5OTPm8VxrPh8/msTL8MQSm5PbzcEuKubmc1MXhLtJYzCfMT2+BBOBm3xuMXFe20xDB
	 khjTzs4Rm4sNZabkfRBktotR2/qM4kScmCm5q02RQgEvDaRhT9lfPSQgD2e6dp2yFH
	 mxbX1sGE0ZQWg==
Date: Wed, 7 Feb 2024 10:49:56 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <me@xecycle.info>, <target-devel@vger.kernel.org>,
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/1] scsi: target: Fix unmap setup during configuration
Message-ID: <20240207074956.GB19965@yadro.com>
References: <20240207021919.7989-1-michael.christie@oracle.com>
 <20240207073336.GA19965@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240207073336.GA19965@yadro.com>
X-ClientProxiedBy: T-EXCH-06.corp.yadro.com (172.17.10.110) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

On Wed, Feb 07, 2024 at 10:33:36AM +0300, Dmitry Bogdanov wrote:
> Hi Mike,
> 
> On Tue, Feb 06, 2024 at 08:19:19PM -0600, Mike Christie wrote:
>  
> > +static int target_try_configure_unmap(struct se_device *dev,
> > +                                     const char *config_opt)
> > +{
> > +       if (!dev->transport->configure_unmap)
> > +               return 0;
Oh, sorry, here it is :)

> > +
> > +       if (!target_dev_configured(dev)) {
> > +               pr_err("Generic Block Discard setup for %s requires device to be configured\n",
> > +                      config_opt);
> > +               return -ENODEV;
> > +       }
> > +
> > +       if (!dev->transport->configure_unmap(dev)) {
> > +               pr_err("Generic Block Discard setup for %s failed\n",
> > +                      config_opt);
> > +               return -ENOSYS;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  static ssize_t emulate_tpu_store(struct config_item *item,
> >                 const char *page, size_t count)
> >  {
> > @@ -776,11 +797,9 @@ static ssize_t emulate_tpu_store(struct config_item *item,
> >          * Discard supported is detected iblock_create_virtdevice().
> >          */
> >         if (flag && !da->max_unmap_block_desc_count) {
> > -               if (!dev->transport->configure_unmap ||
> You removed this check but that callout is not mandatory and exists just in
> 2 backstore modules.
> 
