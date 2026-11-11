Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410632;
	b=flUgV1LsFjSJPxVyeHxlGlPrAJIKfPA59GUvye5hDL/x3TFGp2eQjypwQxWaz+vVm5H9
	 GfzKM4nOhUHq0ercoBq5nTPpRoo+hUR77J80UTbPI/6LXZ4et/kfkgo6XukUnaLW0iu9L
	 XWO+khfbksSW51pLxSuvRARmlJSKP8Sj1AI6IYsyMoN3m0FIG1W3lOpv9BLEGGvUnXgpt
	 VA7VzAg9pTH6DuXsAWt/PO6KdCq9O0k3T1EvcFaHGM0V1O4tDkAweFsJijhrryOb/Zzbh
	 j3F22k0M1FwBvFj2YG22wg5SQSMwlrkatsVzI1xU/YPWURWiAvY2CAGz51c0OV0oesA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410632;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=HeHmUQvnFRk48VpK/V1r5q6/A10R/uDx7AK6P2NG2/Q5PsTNrWDCe1JhWBaP5ZtUeMR7
	 oo2m8GCT2ah0KtGUS99/f7ug+K3+0fpHzssFUoU3cJEK+8IW+qNOR5N47JjApjM42jgXQ
	 IsG2qnnmg+QmnfLnZD3FMYOzYfP77gHXnulZWFEKPkP0juh6Z8L49IhragcsK7ajcfYyD
	 ffWPbU/ixyhtK4BVXvd9UcdH8tQDj+/ZpHE+yN6F28kaRVS5ecWtS/wD1LgGor+V+ryAg
	 i2J3Vtumew8iZctTndKZVBxG9kPz4GVTF941L5tCiKBei/YbXrKPuAjqrQd7vpnVibg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD530606A321;
	Wed, 11 Nov 2026 15:23:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD530606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 75F6F68D17; Wed, 11 Nov 2026 16:23:47 +0100 (CET)
Date: Wed, 11 Nov 2026 16:23:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 03/12] block: allow dropping all zone write plugs on
 revalidation
Message-ID: <20261111152347.GA12574@lst.de>
References: <20261109095144.819709-1-dlemoal@kernel.org> <20261109095144.819709-4-dlemoal@kernel.org>
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
In-Reply-To: <20261109095144.819709-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

