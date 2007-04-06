From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Thu, 5 Apr 2007 19:21:13 -0700
Message-ID: <200704060221.l362LD4s025776@cichlid.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl-63-249-106-23.cruzio.com ([63.249.106.23]:49339 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767492AbXDFCVS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2007 22:21:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Thu, 2007-04-05 at 15:36 -0700, David Miller wrote:
> From: Andrew Burgess <aab@cichlid.com>
> Date: Thu, 5 Apr 2007 15:13:27 -0700
> 
> > David, do you see any other problems with scsi_send_eh_cmnd?
> > 
> > I've switched back to 2.6.18 which seems to not oops 
> > and am happy to try patches.
> 
> Does 2.6.20 with my patch OOPS too?  Does reverting my patch
> make the oops go away?
> 
> If reverting my patch makes the OOPS go away, we need to
> verify if page_address() is returning crap for some reason
> or the length is wrong.

2.6.20.4 with your patch dies in the memcpy (as does 21-gitN)

2.6.20.4 without your patch dies in the subsequent __free_page
with a null pointer ref at 000...008

James should I try your posted patch? On which kernel?

This machine will die in boot on these kernels until I power
cycle it (which somehow fixes the disk/controller for a
while), 2.6.18 continue to work (gets the scsi errors and
continues)


