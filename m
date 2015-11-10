From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4.1] target-core: fix return without a value
Date: Tue, 10 Nov 2015 18:31:47 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511101826430.13780@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1511101329001.18857@file01.intranet.prod.int.rdu2.redhat.com> <20151110185605.GA15668@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbbKJXbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 18:31:50 -0500
In-Reply-To: <20151110185605.GA15668@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-stable@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>, Alex Gorbachev <ag@iss-integration.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On Tue, 10 Nov 2015, Greg Kroah-Hartman wrote:

> On Tue, Nov 10, 2015 at 01:32:10PM -0500, Mikulas Patocka wrote:
> > Fix the warning drivers/target/target_core_pr.c:332:3: warning: 'return'
> > with no value, in function returning non-void [-Wreturn-type]
> > 
> > The patch 35afa65642a9a88c81913377b93a3a66220f8b9d committed to 4.1.11
> > adds a check if device_list is NULL. The patch adds a return statement
> > without a value to the function core_scsi3_pr_seq_non_holder that returns
> > int.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/target/target_core_pr.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

This patch has no upstream equivalent (because the code in upstream was 
already refactored), so none of the rules in stable_kernel_rules.txt apply 
to it. The patch that broke it also has no upstream equivalent.


Documentation/stable_kernel_rules.txt

   --- Option 1 ---

   To have the patch automatically included in the stable tree, add the tag
     Cc: stable@vger.kernel.org
   in the sign-off area. Once the patch is merged it will be applied to
   the stable tree without anything else needing to be done by the author
   or subsystem maintainer.

   --- Option 2 ---

   After the patch has been merged to Linus' tree, send an email to
   stable@vger.kernel.org containing the subject of the patch, the commit ID,
   why you think it should be applied, and what kernel version you wish it to
   be applied to.

   --- Option 3 ---

   Send the patch, after verifying that it follows the above rules, to
   stable@vger.kernel.org.  You must note the upstream commit ID in the
   changelog of your submission, as well as the kernel version you wish
   it to be applied to.

