From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] Allow both megaraid drivers to be built
Date: Mon, 7 Nov 2005 06:15:34 +0000
Message-ID: <20051107061534.GA20888@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD30B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8372 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964789AbVKGGPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 01:15:37 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD30B@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Daniel Drake <dsd@gentoo.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

On Mon, Nov 07, 2005 at 01:05:55AM -0500, Bagalkote, Sreenivas wrote:
> James, the people responsible for megaraid/megaraid_mbox are collecting
> information from our key customers about the impact of moving overlapping
> ids. The concern, I believe, is that some customers who were exclusively
> using megaraid will be forced to use megaraid_mbox. I also see that both
> drivers register_chrdev() with "megadev" string. There is going to be some
> impact on a stack of applications. I am not sure how Daniel's patch solved
> this.
> 
> I sincerely thank Daniel Drake for kicking this issue into high gear. Please
> know that this issue got the attention it needs. Getting customer feedback
> wasn't very fast. How long are you willing to hold this patch?

Note that the current situation is even worse for your customers, because
the Kconfig subsystem only allows to build one driver at a time.  You
don't notice that because all distributions patch that silly check out
again.

Can we at least agree on patching that out ASAP and leave two drivers
handling the same ID (we have cases like that all over already) and then
try to make some progress on removing ids from the old driver independent
of that?
