From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.1] target-core: fix return without a value
Date: Tue, 10 Nov 2015 16:00:59 -0800
Message-ID: <20151111000059.GA4902@kroah.com>
References: <alpine.LRH.2.02.1511101329001.18857@file01.intranet.prod.int.rdu2.redhat.com>
 <20151110185605.GA15668@kroah.com>
 <alpine.LRH.2.02.1511101826430.13780@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbKKABA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2015 19:01:00 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1511101826430.13780@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-stable@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>, Alex Gorbachev <ag@iss-integration.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, Nov 10, 2015 at 06:31:47PM -0500, Mikulas Patocka wrote:
> 
> 
> On Tue, 10 Nov 2015, Greg Kroah-Hartman wrote:
> 
> > On Tue, Nov 10, 2015 at 01:32:10PM -0500, Mikulas Patocka wrote:
> > > Fix the warning drivers/target/target_core_pr.c:332:3: warning: 'return'
> > > with no value, in function returning non-void [-Wreturn-type]
> > > 
> > > The patch 35afa65642a9a88c81913377b93a3a66220f8b9d committed to 4.1.11
> > > adds a check if device_list is NULL. The patch adds a return statement
> > > without a value to the function core_scsi3_pr_seq_non_holder that returns
> > > int.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > > ---
> > >  drivers/target/target_core_pr.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> > 
> > </formletter>
> 
> This patch has no upstream equivalent (because the code in upstream was 
> already refactored), so none of the rules in stable_kernel_rules.txt apply 
> to it. The patch that broke it also has no upstream equivalent.
>

Then you need to say that!

And the fact that a "please take this patch, it's correct but doesn't
apply to upstream" patch is now broken is proof of why I didn't want to
take it in the first place!

Ugh.  How about I just revert the original patch and then you send me
backports of what is actually in Linus's tree so we don't have this
problem anymore?

Oh, and you got the stable mailing list address wrong as well :(

Please fix all of this up and resend.

thanks,

greg k-h
