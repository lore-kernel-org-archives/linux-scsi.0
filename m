From: James.Smart@Emulex.Com
Subject: RE: [GIT PATCH] final SCSI fixes for 2.6.15-rc5
Date: Thu, 15 Dec 2005 09:58:23 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276D38@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:14473 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750756AbVLOO6i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 09:58:38 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mdr@sgi.com, James.Bottomley@SteelEye.com
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> > 1 - fc transport change gets really noisy if targets disappear from
> >     the fabric due to recursion on the workqueue.  I've 
> seen recursion
> >     depths > 40 and it's only really limited by the number 
> of targets
> >     on a fibre channel fabric.  It's unknown (to me) what 
> side effects
> >     this recursion might have if the number of targets is in the
> >     hundreds, which is not uncommon for our customers.  James Smart
> >     is aware of this and is working on a solution.
> >     See my posting of 12/2/2005 and replies.
> >     "2.6.15-rc4 error messages with multiple qla2300 hba 
> ports on fabric".


The patch I just posted to linux-scsi fixes this issue.

-- james s
