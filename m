From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 11:53:39 +0000
Message-ID: <20151209115339.46a09d94@lxorguk.ukuu.org.uk>
References: <55B9CA3B.1030205@suse.de>
	<20151209102453.GE3173@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151209102453.GE3173@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 9 Dec 2015 13:24:53 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On 64 bit CPUs there is a memory corruption bug on probe().  It should
> be a u32 pointer instead of an unsigned long pointer or we write past
> the end of the setupdata[] array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
> Resending because we have shuffled the code around so the patch needed
> to be refreshed against linux-next.  Although I do wonder why we are
> still working on this code since it has never worked on 64 bit systems
> so probably all the users gave up a decade ago.

So this is untested ? If so please make it very clear in the commit
message because the kernel is IMHO getting too full of polished, neat,
recently modified, never tested, never used code.

I agree it would be better if the driver was simply deleted. I've not
even seen an ATP870 bug report in years.

Alan
