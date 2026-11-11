Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410844;
	b=grR7YUpAxrIZU+8PBHFqwatqwien5khEP/XDru5QxgeBJHU2VVT9gqaONuVwl5siFr8H
	 Qa03aEtZisPKpd7KSR8qBLfAOzlPsIz/pQPuHX/R8xot4hMsEspxBpzM8ckjx02a54ufD
	 P5rbCN3Lmv3j983T6Fm4ZLJdb0jfR4f9xPofhn4jNu5lradM3PsD9ZI1oF3NgVEQnzGQx
	 plrbKPWnwBHJ78IL42D63QW5vWZ64w/cQ0p4CEZTPtKLfbBOQW2R7NUjoaKsExnukOyHv
	 9w1ydfAiHybwBxfv5PByg4NBKHADqOCbvkDEy/qPiRW8OWxdZXsz0Mh+bP9lC0mrGAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410844;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=64ioTnF4I2FIJMTgG1FvNofZBHZB9IzCsW/3T5JSbqg=;
	b=DUTtBXQC3MezJgbRhRyd1rMZ0iLPejrdvUC/qMjEV6t2uOdA4/qK1a0ybr17jaw3bG33
	 bYWCCLYFudlqLJrpXvNW27bUbuxX08fCA1jrrPnsa7lzpoke1KmonppT7GdIULjLGCJXB
	 e3p9iaD/0MbX2BEzvbibXRH2VXAggQJFvPkMnJY+5HCs/5SYH/L9dB8gVgdH0AhFLe4s6
	 virVSQdgiAQjBK6aquS8az4uW+cFmoaYmo41XnXMMT6iLXg4Tcp4vqErEKZ+46eBCZmUL
	 5MJR83ic938ISHff+MJYL7RwMxghpmWX4ke4LDyQDr+gwUAS3VD2ttmGDKFvlKfk2TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F4A606A324;
	Wed, 11 Nov 2026 15:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4F4A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C632268D17; Wed, 11 Nov 2026 16:27:19 +0100 (CET)
Date: Wed, 11 Nov 2026 16:27:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 06/12] zloop: fix zone reporting consistency
Message-ID: <20261111152719.GD12574@lst.de>
References: <20261109095144.819709-1-dlemoal@kernel.org> <20261109095144.819709-7-dlemoal@kernel.org>
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
In-Reply-To: <20261109095144.819709-7-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I think the Sashiko comment on this is correct, so more work
to do here..

