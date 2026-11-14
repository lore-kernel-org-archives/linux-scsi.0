Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657338;
	b=Rl1vv5wNPn7Io8Y6h0udWUgS5vZI9MUoQpXCCBSBkZvNL5eLbzKABE1WeDgHRg2cxIuy
	 SOoQKGo6PEzf+ROWNyd5AnntPozBEo6g5AvkbsezyThWRovpTECp92aPttEAB/mPxR4yC
	 Z1TOSQoUlKPdX5D/oO1cYSU7JsExvCiR6U8AJhDq/XMdTrOpu1tPjUvSMlzcWbqnQPazQ
	 d3j8MURnhtqW9Lq7fC9RwD7Gow7cybFlQwHV5nixSbbgdwrE100W675e0Lz+IcxqHBiif
	 h7xk3P22xZZNtamEC9cbOAqO5TLH7Dfg1ygA+qAF4ZLvpKUmLMzntDob4YlChCSo29Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
	b=AHPZMdVV6BkFGTfd1JjiXISJLqg6EkPQZPPYEJi4MEN+Ofuo9MkWn0Rq171MpFluyMfQ
	 I4lv8DoY/LIggVIUq1WMQX5kl/KwZIQ2EsITUqqb0ah8cpms0QmBvoEkXvRJBombQn3HW
	 /Dsht4Dpyk0ziWEfHqUEKTpOgVIKNsXr7u85/58uo5LMQnBWIsdzfEfv69UOkUuyJqOey
	 EgciEKSfd2ScN33tZvp7khR5nA32A8OEnTYxP/8kSMxsf0LTUCG83YhscAs2wIiMuoFNz
	 /iMas8V6zY+ngzaZ30Rr8p+FKM8bxvLkMX517wimAp+W1BSWDUi0MZIXwyRCJvgI47Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MrTBjpIE;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B77606A332
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 11:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69B77606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MrTBjpIE
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4cdc606b47so373829666b.0
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657337; x=1795262137; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=MrTBjpIEXzsSZaANjc7oExJhwGnF+j3pBQoJGLV3AozjECewWnT/dOn8PoCfUIeYGI
         mRgldWBhVoyoY4kjpOu/TkcCPMpetn8bMN74Irqnk0JnK5MAQS777TE3iVfENO0qNvUE
         8qb82pxhdLikkA/6tATGUpByZMee1vHTbdl6A6vtosorr3+hE9wD/mpuH76lS1WAZqyn
         nUdTyabyG8UAyWqGnpYJGfY62DgpvBldD5kNADP5MARyaYxmHHJYDsQkr6qVKrnaldzF
         KHIyaxdpU8Pcl80WjVwUUXXw+yU81KD0D8RdN7wE6Dhf//BzElFXAKq/AgQBu3vGzFII
         7JmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657337; x=1795262137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=tz5wogk1NhC2OPfA6Z99iVQ+ndhc2A/PSuLpVZso6vT8T0Rkd6Pj3lSSWoONlDuM5o
         jRBMWH83VG5WrFqWTJQhMLPYIxltS82A5oW5ctgp2Dlr+uF/cmMdIDzO5J4mj7fkmito
         5c2GUaq+2YJ6o2vo4aRm9Yex3rRJHzp51Tebptlto4cBrAsf/1mlwB9aXzOOYuozCzS/
         Xiyc0+KtSFE4pbt8bofq84YBG+xX2lqOex3ya0R0NSAFvnxP5yEuVWgS+3QTqVkz4YYc
         9FepGb8l/5HTr581hTv3de2XBQBfOTeRXIiaF8YAnXjTRNLbDu6+BRBnXIPPfgbOJpAt
         KLjw==
X-Forwarded-Encrypted: i=1; AL+hErHfssnpM4mIbU178EEnyIFtCQAbhTjJNLSHM3Jsr5YqqdviKEzN5ky/JFre4CitFL0vTo41fXcf4qy4@vger.kernel.org
X-Gm-Message-State: APuU4Z+MYyAlZWf7LFseqDyy6tNkYI+DaG8Kq2OP4OgPrdVAklvbZVI0
	56Be6updxWzyD5SbtXUiU3gtQiIpHBveAwJNjYHG9bvV6SqShPTkmm7v
X-Gm-Gg: AYBFou29oOOXA3uND3A0xGRiv0VevpdizuA9pdpdmJinRF2eGaZjc9Xhk3mvuaxQk0F
	b8bffLQUpNYTLFcSgfSkrY5oHQUMOfrzix5HtnoB4vsPiMSpbnd0Rmy6egf2pS3Ch6oU507hJzi
	p+kUqlvgKBI48KqZ7RGFoY/cC/767jsP+8CK76/MjD7p4Cu3HMDziSZi3YdNRnSLEmUEGQYhHwb
	s9QK6lOXmp2GxSAEGuDt2QuGK1y1sM0DWV87bpZ6he75aCpLtQZSpz4b8/Xwosbtttz1ZimFU3p
	Qz/2d23hDOtXS2/gajMQD/xu0D8scc3S2Xd2yuPy3UY6qlAbXMGuv57dF10k55ax3KQn7L2UH7E
	wtN4bty2BMrJd+nm8tiaWK5KqeMWDv5iSRB1PrMjFmexb21gcPscocVLAWrYNA6yC8rfVJIbCyo
	U97puLUmyzPKZe1Dd0VmSLZA6Ae7wtpPmlbubrNIHO/qLlVAlrR32D6rrc1Vflyf1lg90YGcvEp
	iNMZDmwcNPx236hPRK0DFm3ueLkSz0/j0T1Hbsnr8i+lvATV0gSCcZesOUl47kfCVmxaFb8SIaf
	tJZjLuZ5rxrHaMrnVBUdy7vkh5p0ZwGfF/p75+a1uW71lNH4JY+7uMKpnbEgO903DqHI/6Jc0/N
	V9tyinasr7oM=
X-Received: by 2002:a17:907:3e10:b0:c40:231:6eab with SMTP id a640c23a62f3a-c5096370c31mr441592966b.16.1794657336589;
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b41f44sm206223866b.31.2026.11.14.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Date: Sat, 14 Nov 2026 12:55:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avhMN39TECaur0sS@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
 <20261111151202.GA11391@lst.de>
 <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>

On Fri, Nov 13, 2026 at 11:25:57AM +0100, Alexander Mikhalitsyn wrote:
> Hi Christoph,
> 
> On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> > I've seen setups where people use fuse to mediate access to sysfs
> > sysfs in odd ways.  No idea if that's still around, but if so, this
> > patch will break it.
> 
> 
> Oh, that's painful. Do they use backing files for that?
> It's a relatively new feature in FUSE...
> 

Very unlikely that they use FUSE passthrough and if they did
very unlikely that it would break their filesystem.

The API for fuse passthrough is that the server requests to setup a
backing file before open via ioctl and if ioctl fails (as this patch
does) then server falls back to non-passthrough open.

The ioctl can already fail for many reasons such as MAX_STACK_DEPTH on
procfs as the commit message says, so server needs to cope with the
fall back.

Thanks,
Amir.
