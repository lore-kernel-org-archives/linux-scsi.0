Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410682;
	b=jRp0wCDJMD4hBxDRhdIlmO8iHBElsAHdJFi6AdohERfAIPL2NfljFFyzZyNuH/0SsF+N
	 BTno8vCA2RpFUqO3cMGorLqlCIa63s4PNJ0bMmin1yk9q+7gHhLELj+vk3BetmiTaWrCd
	 v/M60L3okXYI6juYVfQBoONds8jUH+AK9Jlb4nWXNHjqiiXqqkV1bN90iBbfMDEXskhSd
	 AeJfO9iqpLp8ZfvSKEf82C+DQIMcCmJwiHpCsjPjP0yQXt/T/vVBV4Y8A47hBoMqTMK6w
	 461OwxqQL/+YXUm5ZH9TBKPQMy9Kmw57Wwr/xCuEBT4hUuHZnwrfylRL0PVkWRNxfBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410682;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=NTSNoJTfg+FJQYZHCtK1FOSCJXeFSAoXYiac/P9FLATwtb89z90/KA2fvDP3+s4AHNnS
	 QhlAKm3d64145SXeYSpQLKDY8JiiV4eFZvWB7OJ801AWzP7uYba0EtTH9sCs2d9v4GY94
	 3cO71W9q6j7gJ60KG8CzRvo3wfzXGQysnyHeTYikJdMGvKV10Obz+EaAcM7lT2jDvtGHd
	 w2GtFiQFnNM/zJXWYX+fiQEmA+S5XVMA3rqGWs7fQV7PIf847HlKKILTQ0FD3MtF/ytOJ
	 9LCnhpSrMj5ZhAjaGU9tlnktCTnkaR4udq19RQtkerYjzhff9D68XW/pjvFsKfzuj8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD468606A893;
	Wed, 11 Nov 2026 15:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD468606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6911368D1C; Wed, 11 Nov 2026 16:24:38 +0100 (CET)
Date: Wed, 11 Nov 2026 16:24:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 04/12] block: introduce storage element management
Message-ID: <20261111152438.GB12574@lst.de>
References: <20261109095144.819709-1-dlemoal@kernel.org> <20261109095144.819709-5-dlemoal@kernel.org>
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
In-Reply-To: <20261109095144.819709-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

