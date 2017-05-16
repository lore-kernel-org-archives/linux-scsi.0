From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] sd: fix sysfs writes to "provisioning_mode" and
 "zeroing_mode"
Date: Tue, 16 May 2017 08:52:39 -0400
Message-ID: <1494939159.1081.52.camel@localhost.localdomain>
References: <1494875606-6298-1-git-send-email-emilne@redhat.com>
         <1494879289.2567.3.camel@sandisk.com>
         <1494882178.1081.43.camel@localhost.localdomain>
         <1494882849.2567.6.camel@sandisk.com>  <yq1mvades4t.fsf@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752541AbdEPMwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 May 2017 08:52:41 -0400
In-Reply-To: <yq1mvades4t.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-05-15 at 17:18 -0400, Martin K. Petersen wrote:
> Bart,
> 
> >> So, are you suggesting we change all the other sysfs store routines?
> >
> > I will leave it to Martin and James to comment on this.
> 
> As I mentioned a few weeks ago, I have a patch that converts all these
> to sysfs_match_string(). Now that the latter is upstream I intend to
> post the patch.
> 

OK good.  One other thing I wanted to check -- I assume it is
intentional that the provisioning mode cannot be set back to "full"
once the device probe has set it and/or it has been manually set via
sysfs?

-Ewan
