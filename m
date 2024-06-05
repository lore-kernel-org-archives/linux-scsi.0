Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14361946A6;
	Wed,  5 Jun 2024 08:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717576418; cv=none; b=ect/AN0G0/lltsCup3+D3TCbPOq756EZXB2gGKUuTx3aC26mvgJ0W4SDuTH3Yjz2iMGt/7K5wmqgvwgvu0AwlOW19O18DTQ2dNVeJtZOP1BBECuNflygKQs/E3Nj6pRGOIJU/uBrULI1kp4oIUvIKX6EKNrzRslg6EZlcTgEzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717576418; c=relaxed/simple;
	bh=0ki2g+VTCwzVsFNHek0KlzrsIdaBwLLZykPJAo3HDAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQrZW+i9A7UbyBQLBlR7Qv00FmNE5Aybvy0FM2COudbzRJgBK8V0fwwmUMw2D9k1LlMOgP3h5ihbquM42GvaUkQQGpm4UC3KGwNZu1yMRIdd6GCMAFkIHCLcSAQ22pvJnlPtivy7eXOY8x/tgC6x81z9VuZJQ5iGI3gpMcVpsIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a68ee841138so395213666b.1;
        Wed, 05 Jun 2024 01:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717576415; x=1718181215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgwvGbeQ51aSYhN/1Av3F23kdDADeU11qf5jY73T9Ig=;
        b=nq8DmIWapq69t9aeJ9UOAaGDBdw/0YEQSz8QNyFiLoDvOcl23yGTs08TcAsJ5dZDpd
         g5jG3mpGXz+jpVbyxFLa5qaaMpEx+M7SzAuRHDGfWL/ywqS28dRSviwJAp6TbrGJf7/u
         HCbpunG7BoK9/03mOdGYTUoOty2+5lTYBU8akMLkBdVGPFSCX54/wvbmdfAThxdjhW9I
         e2jlBCfuIRq3SwnLbdkXyclXjXCvD40olmb7vtGj8cT7P4LtbtyjKE2LkQv5rbttRjsG
         7VQPgEjnIZvW50SOtoeuWjndr4vkw3ZVg0Br/Up2lVPgTKGMkPmtxVZ5OVoA1YwKke88
         2foA==
X-Forwarded-Encrypted: i=1; AJvYcCV95xsQRPi+AAoJCH178Mzoc5kN8RWAM4lSD6ezKSO1tTzbmKaShmrc684ttP5MnKi0kZzoOkgrPf5VMuoeQ8rdicnEV5aSCiNawnmd9DOeaSyk1e5YvGqFgJQDYUK7YLvPg2hY+tB5Gg==
X-Gm-Message-State: AOJu0Yy0e4X3xan2h6CBywWAcW0mmd6fZkddchngR+Rqqjo+lukRmvZA
	d7jkDSbUYhqGKxlJTmVL0vU77JHOBzdrL7WnjGu2cH/8uE/RFnKT2rl/LQ==
X-Google-Smtp-Source: AGHT+IFhhK3cHNOzxeodK/r10BVtnQPMSBk/Ho3mnf7jPU6AFdAroZauygoZN8/FzYprLbC6102FbA==
X-Received: by 2002:a17:907:9707:b0:a68:9ce3:c896 with SMTP id a640c23a62f3a-a699fa9bcf3mr130111166b.24.1717576414865;
        Wed, 05 Jun 2024 01:33:34 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68c99d5fa4sm563584566b.189.2024.06.05.01.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 01:33:34 -0700 (PDT)
Date: Wed, 5 Jun 2024 01:33:32 -0700
From: Breno Leitao <leitao@debian.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, leit@meta.com,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mpt3sas: Avoid test/set_bit() operating in non-allocated
 memory
Message-ID: <ZmAi3DoEBuv4txOL@gmail.com>
References: <20240531180055.950704-1-leitao@debian.org>
 <Zlo81SBdvflQ_38O@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zlo81SBdvflQ_38O@kbusch-mbp.dhcp.thefacebook.com>

On Fri, May 31, 2024 at 03:10:45PM -0600, Keith Busch wrote:
> On Fri, May 31, 2024 at 11:00:54AM -0700, Breno Leitao wrote:

> > @@ -8529,6 +8535,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
> >  	ioc->pend_os_device_add_sz = (ioc->facts.MaxDevHandle / 8);
> >  	if (ioc->facts.MaxDevHandle % 8)
> >  		ioc->pend_os_device_add_sz++;
> > +
> > +	/* pend_os_device_add_sz should have, at least, the minimal room
> > +	 * for set_bit()/test_bit(), otherwise out-of-memory may occur
> > +	 */
> > +	ioc->pend_os_device_add_sz = ALIGN(ioc->pend_os_device_add_sz,
> > +					   sizeof(unsigned long));
> >  	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
> >  	    GFP_KERNEL);
> >  	if (!ioc->pend_os_device_add) {

> Do we need similiar ALIGN for _base_check_ioc_facts_changes() too?

Yes, that would help as well. Since it will protect
->device_remove_in_progress and others from the same problem.

Let me send a v2.

Thanks!
