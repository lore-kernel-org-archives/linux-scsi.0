Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410946;
	b=bVXbQfk9VGJuZXdudq4a/gbY1/OuH92rEokdKAjosnHkfDjwgBrGvazCsUndCCEX4Qzc
	 dyUNfeGPi7Ww/xH7y/SVwepEnysf944YohtzjfJioir2C6FUoUHM+ECMXQJFosC9NP/L6
	 qAqCWA+TCFMJIwomJxfJdEa15lA+szYZqYAdullGvt8fyJP+emHIXtV37YklDWkvnP5qT
	 r8ILY/Zt64JiTOcriLuMcWoMiy/QuuZU61rbZUkUKsHWB+5pykh3R7ubt9iLfk+qZ2+uj
	 7xnIocfWhrWayNMZyoa006DzDvo7Fa0mLYT7Bgy2DfcvyDofwet68rXacYsSNvyFJ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410946;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=EHG254rVgiwUA6Af5N1qUqnbbHgIgu+tppS2FBaUOpiyaTAeq4hIcErGBw3Xhx+HjdiL
	 LVvSm1dNoQTdNy2aauCwaBzTb8ztDUyiKg/0lOWaJ3+sPtkbMDUCKDNH87elpUr3gF/Gd
	 QxINigLPbQiQMDYLtpkOscreRTvDxS7PbJSTVlJbnwn65z65Qo06H2iN92VdOrMM9zZwa
	 FLsRGXrF/2FDB/dRssLC1xoF/9IIFiKvX/hX1G8xfr0CVGcPHJQy1qeCZCuUXuzkEYdIq
	 k2l6YqVOSfzJ1DpZ40j+DFFOlAQfdWGfC6BzpwilahGtDMcaZYzY/TJ2n5bD/NiOuLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168C606A324;
	Wed, 11 Nov 2026 15:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5168C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E012D68D17; Wed, 11 Nov 2026 16:29:02 +0100 (CET)
Date: Wed, 11 Nov 2026 16:29:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 10/12] scsi: sd_zbc: always revalidate zones for
 disks supporting head depopulation
Message-ID: <20261111152902.GF12574@lst.de>
References: <20261109095144.819709-1-dlemoal@kernel.org> <20261109095144.819709-11-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109095144.819709-11-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

