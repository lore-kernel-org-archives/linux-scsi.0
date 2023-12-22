Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2725390;
	Fri, 22 Dec 2023 05:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1ioA52TK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ehc4XtP4Bj0BvCjkQ22XyePVUvM6sFI9MypjiGFf6p4=; b=1ioA52TKDFyEux+guT8Y7dRYn9
	y3Vag6l50pcyopHv+6YxSnjOWaWSP+HpKqUUX3zxOPtGHAWR9iW7mKrtm87QZiniZzu++ghUe8kt0
	pENneWiaWnqT1q2tG8cS8o4qGA6dEw+dZxkUSzshr6eAxw0rdR9DeO2W8RUCpwoTX6nd4XMoSn1Wc
	s6Jppvp/eADozCa7HzU2v3QnK/yUQkM5wc/MSS6J+kh+9BXLeukFrjQhCpG11iAsfsNzFLedtiWlK
	tcZONDQYLlCn7iIR2eWSTrGIiKOq7peRJ9Dp7GbQfYTB0sW6j2gfltkyOfLRHXsCmfd3fZbuprVJh
	uQ2yQ2xQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGYE7-0050F9-2x;
	Fri, 22 Dec 2023 05:37:39 +0000
Date: Thu, 21 Dec 2023 21:37:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
	lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYUgo0a51nCgjLNZ@infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYUbB3brQ0K3rP97@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 22, 2023 at 05:13:43AM +0000, Matthew Wilcox wrote:
> It clearly solves a problem (and the one I think it's solving is the
> size of the FTL map).  But I can't see why we should stop working on it,
> just because not all drive manufacturers want to support it.

I don't think it is drive vendors.  It is is the SSD divisions which
all pretty much love it (for certain use cases) vs the UFS/eMMC
divisions which tends to often be fearful and less knowledgeable (to
say it nicely) no matter what vendor you're talking to.

