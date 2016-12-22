From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH ] tcm_qla2xxx - Enhancements to the tcm_debug jammer
 code to jam only data movement commands
Date: Thu, 22 Dec 2016 16:59:43 -0500 (EST)
Message-ID: <1298100153.9078410.1482443983204.JavaMail.zimbra@redhat.com>
References: <416360573.9077781.1482443162576.JavaMail.zimbra@redhat.com> <1482443642.4358.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48020 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758521AbcLVV7t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 16:59:49 -0500
In-Reply-To: <1482443642.4358.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: himanshu madhani <himanshu.madhani@cavium.com>, nab@daterainc.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche@sandisk.com>
> To: "himanshu madhani" <himanshu.madhani@cavium.com>, loberman@redhat.com, nab@daterainc.com
> Cc: linux-scsi@vger.kernel.org
> Sent: Thursday, December 22, 2016 4:54:30 PM
> Subject: Re: [PATCH ] tcm_qla2xxx - Enhancements to the tcm_debug jammer code to jam only data movement commands
> 
> On Thu, 2016-12-22 at 16:46 -0500, Laurence Oberman wrote:
> > Added the possibility of blocking only specific SCSI data movement commands
> > but allowing TUR'S to pass.
> > This has been helpful for debugging many driver/array interoperabilty
> > issues.
> 
> Hello Laurence,
> 
> Your work is appreciated and also that you are posting this patch for
> inclusion
> in the kernel. However, since this is functionality of which I think that it
> is
> useful for all target drivers, shouldn't this kind of functionality be added
> to
> the target core instead of one specific target driver?
> 
> Bart.

Hello Bart

Thank you for this.

Indeed, That's on my plate for next year to try rework this into the target core.
Its used a lot here at Red Hat for testing the F/C drivers and multipath via the LIO target server.
The first version of this is already in that allows jamming of all commands.
I wanted to share the enhancement which is very useful and has been working well here but indeed if we have this in the core its better.

I may have some questions for you as I work on that next year.
Many Thanks Bart for all your help this year.

Regards
Laurence
