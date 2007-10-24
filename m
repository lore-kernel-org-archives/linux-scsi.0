From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC: 2.6 patch] nsp32_restart_autoscsi(): remove error check
Date: Wed, 24 Oct 2007 18:54:34 +0200
Message-ID: <20071024165434.GZ30533@stusta.de>
References: <20071024162515.GV30533@stusta.de> <1193244072.3396.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37210 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764105AbXJXQyG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 12:54:06 -0400
Content-Disposition: inline
In-Reply-To: <1193244072.3396.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: yokota@netlab.is.tsukuba.ac.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 12:41:12PM -0400, James Bottomley wrote:
> On Wed, 2007-10-24 at 18:25 +0200, Adrian Bunk wrote:
> > The Coverity checker noted that we'll anyway Oops later when we ran into 
> > this condition - and the error check didn't prevent that.
> > 
> > Considering that the error condition shouldn't be possible, and we are 
> > not able to handle it easily, this patch simply removes the pointless 
> > error check.
> 
> This is the one where I said I don't like the fact that you're removing
> the explanatory message that's printed before we crash.  if you want to
> shut coverity up and stop sending the patch, I'm happy adding a BUG();
> after the nsp32_msg().

Sorry, I missed your answer when resending since it was in a different 
thread.

I'm still not convinced we really need the nsp32_msg() here but you are 
the maintainer and it's not a big deal anyway

A BUG() would IMHO be similarly pointless as the nsp32_msg() at this 
point and there's no value in changing code only for the sake of the 
Coverity checker.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

