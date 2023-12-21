Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F62760B8;
	Thu, 21 Dec 2023 20:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OEWlua4W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WHHdz+wtVwYfCmTJUyu+3iOhIuWJtXHqo98nT5qe+5U=; b=OEWlua4W+Rjf6fYb2pKNd8mklz
	SAMeX5fGAJPMfXuanODlQ3CcAY824bvRhsevJV37jaUbhkHUm3P3Ud4Pi0Cw7dgr5OHdSqo03FenM
	ib4oHKHAUp3jgcZHfgjODZ/Qy9fqy317ppd5Q2EzAvCNXw2S+U58lb0bQHoumeFf3A0t7NyMsQmad
	Ji86yLXz7KSUz5J5HUiCu/ckqd6mFT+9cDdURrW4JOagkpKpNtm40uUMsPQukuHv1xOqNp42bkPGS
	XDBAgpyqR/V9rE9SJo86VXheefrbY5st7V1iGDPIFEIcUWAXDTsc5cW9lw1HjkxP6J3giwphYXjkw
	6380Q7VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rGPrx-0067eC-RW; Thu, 21 Dec 2023 20:42:14 +0000
Date: Thu, 21 Dec 2023 20:42:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYSjJdF1wyqeCFhU@casper.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>

On Thu, Dec 21, 2023 at 12:33:08PM -0800, Bart Van Assche wrote:
> On 12/20/23 07:03, Hannes Reinecke wrote:
> > I would like to discuss
> > 
> > Large blocks for I/O
> > 
> > Since the presentation last year there has been quite some developments
> > and improvements in some areas, but at the same time a lack of progress
> > in other areas.
> > In this presentation/discussion I would like to highlight the current
> > state of affairs, existing pain points, and future directions of development.
> > It might be an idea to co-locate it with the MM folks as we do have
> > quite some overlap with page-cache improvements and hugepage handling.
> 
> Hi Hannes,
> 
> I'm interested in this topic. But I'm wondering whether the disadvantages of
> large blocks will be covered? Some NAND storage vendors are less than
> enthusiast about increasing the logical block size beyond 4 KiB because it
> increases the size of many writes to the device and hence increases write
> amplification.

It's LSF/MM.  If this session is being run as a presentation rather than
discussion, it's being done wrongly.  So if you want to talk about the
downsides, show up and talk about them.
