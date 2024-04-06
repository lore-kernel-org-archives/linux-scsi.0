Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED1F13ACC;
	Sat,  6 Apr 2024 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712415978; cv=none; b=EwD9fbSmeTiI+Hog46qr/bLjd4rS7fmvEiVKeb0glr+T0KLrx+ei5l6clK5ma0j4AfuDlhoCtzX4FQ9VRbvOrH5t2Ezl9X3gOZOw8UKtvMzLWSAYqb6Ww1Chxlfxq00yRUUQTJa067/X4J8xmGuRXA8TPIjaCV5fwKCDyIOEfcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712415978; c=relaxed/simple;
	bh=czv1wlJv+8Z6Fn/G5Q2EAdZ33y6snIOYmvP/YYPbmhQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S+8I6re0++GLkxuZsCj04LQnxhrw80IIxA6xmGPN5Mex3FPUOBFEI3hASFMCfzt5ZOCSkrubmLw6hYYq3l76jVcGSi1iCybF9iukQNpTQoPsN4m/Agl09iP4kqLkglzJuca8kcKXNXUdQ4eTBjvFHDFgjMbnN+wPTLMy3Em5CWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=fZnWEJzZ; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=xbL/eo/c; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="fZnWEJzZ";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="xbL/eo/c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712415976;
	bh=czv1wlJv+8Z6Fn/G5Q2EAdZ33y6snIOYmvP/YYPbmhQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=fZnWEJzZskBtFWsto8W9hHuEIRtBCc2uVIoamSATAuykilAlnpQDIWmLWQAT4nqUc
	 BVm3j6lLi7O3Byz/JQT7P7SkbeWkNl0v1FazKDS74wkUy6/N/RGyN60H93qXp6enSl
	 tG7AwYloTNO1SiNhx/8ndrPfFz08wdiD1U3B8KSQ=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 34EA912865E0;
	Sat,  6 Apr 2024 11:06:16 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id rxd02Xl2f5E4; Sat,  6 Apr 2024 11:06:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712415975;
	bh=czv1wlJv+8Z6Fn/G5Q2EAdZ33y6snIOYmvP/YYPbmhQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=xbL/eo/cxJfOhjs7G2hY0Y6bZklYo2+yVPBSAJjee8qi2agZqWWKPuOS2pmSRuvhp
	 cqKIqUlyEY+ZwyS1ovmV4ntbvx+LvzJO/bc0J8V/LTOMD/G8BlGDdWVfd8muVgc2B+
	 NJL1gu40+OCuoCcDjLqRQ/6HpInoqwNM3JTp4myY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 82D1312865B0;
	Sat,  6 Apr 2024 11:06:15 -0400 (EDT)
Message-ID: <6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
Subject: Re: Broken Domain Validation in 6.1.84+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: John David Anglin <dave.anglin@bell.net>, Bart Van Assche
	 <bvanassche@acm.org>, linux-parisc <linux-parisc@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
Date: Sat, 06 Apr 2024 11:06:14 -0400
In-Reply-To: <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
	 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
	 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
	 <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
	 <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 2024-04-06 at 10:30 -0400, John David Anglin wrote:
> On 2024-04-05 3:36 p.m., Bart Van Assche wrote:
> > On 4/4/24 13:07, John David Anglin wrote:
> > > On 2024-04-04 12:32 p.m., Bart Van Assche wrote:
> > > > Can you please help with verifying whether this kernel warning 
> > > > is only
> > > > triggered by the 6.1 stable kernel series or whether it is also
> > > > triggered by a vanilla kernel, e.g. kernel v6.8? That will tell
> > > >  us
> > > > whether we need to review the upstream changes or the backports
> > > >  on the v6.1 branch.
> > > 
> > > Stable kernel v6.8.3 is okay.
> > 
> > Would it be possible to bisect this issue on the linux-6.1.y
> > branch? That probably will be faster than reviewing all backports
> > of SCSI patches on that branch.
> The warning triggers with v6.1.81.  It doesn't trigger with v6.1.80.

It's this patch:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=cf33e6ca12d814e1be2263cb76960d0019d7fb94

The specific problem being that the update to scsi_execute doesn't set
the sense_len that the WARN_ON is checking.

This isn't a problem in mainline because we've converted all uses of
scsi_execute.  Stable needs to either complete the conversion or back
out the inital patch.

James

