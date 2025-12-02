Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CAC2FD1CE;
	Tue,  2 Dec 2025 05:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655133; cv=none; b=ec4qkq3bVIgf0WnHRPTV8+Mdz+COw8AhXPInZyyFv+Ud9zAZkuiKF8wGyAubgHNt6eJbq0JyZDUlxqeAKuwSL8Eej2r+G08+d3wIw+bMeme0hGPy+V/zUkqiyNrEAUKlioAN+bntRQKYWifkr/MI1opn9sjrgcXvtUz/A8d/jGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655133; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l525Xwjoozuly8SAfSTyuEqG4l9GOX5xSoYG4rwC6KegMFzwPlbxtZF3PQmZCuaSZoMc+ABjZSdgvS1nHbFcXX6YU+x7V067jGry1pfws3KLvyJYqVoWgkqtXAaare4V4OCEDVlH1YVagv+LeiqqwCjM0xQw1nowv5Datqi0vJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C7BB68AA6; Tue,  2 Dec 2025 06:58:49 +0100 (CET)
Date: Tue, 2 Dec 2025 06:58:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Mike Christie <michael.christie@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH v3 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Message-ID: <20251202055848.GB15965@lst.de>
References: <20251201214329.933945-1-stefanha@redhat.com> <20251201214329.933945-3-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201214329.933945-3-stefanha@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
