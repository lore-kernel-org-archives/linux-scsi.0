Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A31C84DC;
	Sat, 24 Jan 2026 23:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769296892; cv=none; b=PF9F/eOaRoGiNj//GygKwFR2nhi291cLuwO2eiD3mHfLk7xIOvEBER+Y+m+81SrvsIOIPo2Sm8PeW0xx57Lhad/s5Sy6vrYpwnFROeV/ji6CbBKPMoAr7SD017raNGH83YKfG+9jwlvZd0v8EZrUKFFlnP5uAnt01WxkdPdv/uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769296892; c=relaxed/simple;
	bh=Bvq+TLhiwOOL92xm1UsF0bamKLs2yBBjaAgpeY4abJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euIQXNX9LgBev4D4+Ilz67pbYv18MPw5vMK5SXgQrDoHQ3yv49rXEFcTlxwcX4WexCObjP6RiHr0UKEUsrYWWtKh+IMZbKfVfkMxFHyGNTXSEUIiHcUfiGt697PbIMHLE+9A480eFlFxTzAAxqg2uZ1OPIIvPVhrPlmMJffIL6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz; spf=pass smtp.mailfrom=ucw.cz; dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b=rfx1R6lW; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b="rfx1R6lW"
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 03555327EDA; Sun, 25 Jan 2026 00:21:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
	t=1769296881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0OpH0KF+2y13vEGNxyfpLdoVe3Uw1KoWHP7IMeNPLuU=;
	b=rfx1R6lWPCEqtOJlYZGFzerBp7ov1CSc+0jeLuu9gcoXKdo4CFBHH8chTDbdib1XZSQ0Vg
	qkyxWru4M9QJlT5ZXjvv1cNtOqjcJJQLuLBKSlMDfpnW41oliIk0XttFWxvNpz6UzxP1ia
	mPyKwPqljHjwb8kDdxJ58m3NEGCNQxo=
Date: Sun, 25 Jan 2026 00:21:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Markus Probst <markus.probst@posteo.de>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 0/4] leds: extend disk trigger
Message-ID: <aXVT8AzgHbr8tbsT@ucw.cz>
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>

Hi!

> Extend the disk trigger
> - to allow configuration of the blinking delays
>   and whether the led should be kept on, on idle.
> - to allow an individual led to be mapped to an ata port

I have used led trigger before, and it annoyed me than "constant disk
activity" resulted in "constant LED blinking" instead of "LED
constantly on". I would not mind if that was fixed.

Thanks and best regards,
								Pavel
