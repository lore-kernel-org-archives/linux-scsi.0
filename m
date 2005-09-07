From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Pending patches
Date: Wed, 7 Sep 2005 12:42:36 -0700
Message-ID: <20050907194236.GA26071@us.ibm.com>
References: <Pine.LNX.4.44L0.0509061611410.32674-100000@iolanthe.rowland.org> <1126104473.4823.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49580 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932233AbVIGTnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 15:43:02 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j87Jh1HS013405
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 15:43:01 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j87Jh1pu092414
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 15:43:01 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j87Jh1un002984
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 15:43:01 -0400
Content-Disposition: inline
In-Reply-To: <1126104473.4823.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2005-09-06 at 16:17 -0400, Alan Stern wrote:
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112238726326927&w=2

On as542. The first hunk of the diff is already in (declare of
scsi_host_set_state). The second hunk looks good (SHOST_RECOVERY label).
The third hunk I will take in combination with the other patch that
effects the scan code. This should have probably been
another patch.

> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112238771326644&w=2

Have not looked at this yet, but will look at it in combination to the
above scan change.

> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112238804301664&w=2

Do we need to revist how we are walking these lists for cleanup post
James's kilst fix / update?

> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112238825727146&w=2

This looks ok for an added check, but I guess I need to look at old mail
and understand how we got here with the added scan mutex.

> 
> I was hoping that Mike Anderson would review these, but since he hasn't
> I'll take a look.

Sorry asleep at the keyboard on these. Comments above if you have not
already looked at them.

-andmike
--
Michael Anderson
andmike@us.ibm.com
