From: Andrew Morton <akpm@digeo.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 14:46:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E0E29D6.9ED7CA72@digeo.com>
References: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
	   of "Sat, 28 Dec 2002 13:50:51 MST." <770128112.1041108651@aslan.scsiguy.com> <200212282224.gBSMO5h03843@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley wrote:
> 
> gibbs@scsiguy.com said:
> > Hmm.  The only previous bug report I had in this area was related to a
> > missing cast.  That was fixed, but I guess it wasn't enough to solve
> > the problem.
> 
> It looks like possibly a config option that doesn't exist (and a possibly
> improper reliance on the dma_mask default value---which should work almost all
> the time, but it's safer to set it).
> 
> Andrew, could you try the attached (untested) patch and see if the problem
> goes away.
> 

That fixed it, thanks.   Tested with:

	CONFIG_HIGHMEM4G
	CONFIG_HIGHMEM64G, mem=4G
	CONFIG_HIGHMEM64G, (7G)
