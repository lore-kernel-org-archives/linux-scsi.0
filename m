From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: crash in iscsi/scsi initiator with linux-4.15.0-rc1
Date: Fri, 1 Dec 2017 14:36:40 -0600
Message-ID: <004101d36ae4$17e556b0$47b00410$@opengridcomputing.com>
References: <000201d36ac5$dc96d390$95c47ab0$@opengridcomputing.com> <1512153175.30220.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from opengridcomputing.com ([70.118.0.34]:43162 "EHLO
        smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751089AbdLAUge (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2017 15:36:34 -0500
In-Reply-To: <1512153175.30220.76.camel@localhost.localdomain>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

> > Then I hit this crash.  Has anyone else encountered this issue?  Wondering if
> > there is a fix handy. :)
> >
> 
> This is the same problem that is being discussed under the thread:
> "[PATCH] scsi: fix race condition when removing target".
> 
> We had good test results with both Jason Yan's patch and Bart's patch
> applied, however the ultimate solution is still in progress, see James'
> comments.
> 
> You could also try reverting fbce4d97fd "scsi: fixup kernel warning
> during rmmod()" if you just need to get past this.
> 
> -Ewan


Thanks Ewan, I'll back up that commit just to verify I'm seeing the same issue.  I'm also happy to test any final fix.

Steve.
