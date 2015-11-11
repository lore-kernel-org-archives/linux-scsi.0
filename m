From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4.1] target-core: fix return without a value
Date: Wed, 11 Nov 2015 07:06:42 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511110700180.13128@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1511101329001.18857@file01.intranet.prod.int.rdu2.redhat.com> <20151110185605.GA15668@kroah.com> <alpine.LRH.2.02.1511101826430.13780@file01.intranet.prod.int.rdu2.redhat.com> <20151111000059.GA4902@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151111000059.GA4902@kroah.com>
Sender: target-devel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Martin Svec <martin.svec@zoner.cz>, Alex Gorbachev <ag@iss-integration.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Tue, 10 Nov 2015, Greg Kroah-Hartman wrote:

> On Tue, Nov 10, 2015 at 06:31:47PM -0500, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 10 Nov 2015, Greg Kroah-Hartman wrote:
> > 
> > > On Tue, Nov 10, 2015 at 01:32:10PM -0500, Mikulas Patocka wrote:
> > > > Fix the warning drivers/target/target_core_pr.c:332:3: warning: 'return'
> > > > with no value, in function returning non-void [-Wreturn-type]
> > > > 
> > > > The patch 35afa65642a9a88c81913377b93a3a66220f8b9d committed to 4.1.11
> > > > adds a check if device_list is NULL. The patch adds a return statement
> > > > without a value to the function core_scsi3_pr_seq_non_holder that returns
> > > > int.
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > 
> > > > ---
> > > >  drivers/target/target_core_pr.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > <formletter>
> > > 
> > > This is not the correct way to submit patches for inclusion in the
> > > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > > for how to do this properly.
> > > 
> > > </formletter>
> > 
> > This patch has no upstream equivalent (because the code in upstream was 
> > already refactored), so none of the rules in stable_kernel_rules.txt apply 
> > to it. The patch that broke it also has no upstream equivalent.
> >
> 
> Then you need to say that!
> 
> And the fact that a "please take this patch, it's correct but doesn't
> apply to upstream" patch is now broken is proof of why I didn't want to
> take it in the first place!
> 
> Ugh.  How about I just revert the original patch and then you send me
> backports of what is actually in Linus's tree so we don't have this
> problem anymore?

The original patch that caused this compilation warning fixes some 
crashes, so you should not revert it. You can work with subsystem 
maintainers on backporting the refactored code from upstream to 4.1 - I 
don't know how hard or possible it is.

Mikulas

> Oh, and you got the stable mailing list address wrong as well :(
> 
> Please fix all of this up and resend.
> 
> thanks,
> 
> greg k-h
