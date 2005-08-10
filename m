From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: exporting TCQ functionality to the kernel in SYMBIOS/NCR 53C8XX driver
Date: Wed, 10 Aug 2005 17:36:32 +0100
Message-ID: <20050810163632.GC16724@parcelfarce.linux.theplanet.co.uk>
References: <200507271133.33723.philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47074 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S965204AbVHJQdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 12:33:51 -0400
Content-Disposition: inline
In-Reply-To: <200507271133.33723.philipp.reisner@linbit.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, Jul 27, 2005 at 11:33:33AM +0200, Philipp Reisner wrote:
> Hi Matthew,
> 
> Does this patch makes sense to you ?
> Could you consider this for inclusion into mainline ?

Does it actually do anything?  The sym2 driver doesn't use the generic
midlayer queue tagging code at all yet, so could this flag ever get set?

I must admit, I was hoping you'd done the work to make that happen, but
I guess I'll have to do it myself (which will make this patch irrelevant).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
