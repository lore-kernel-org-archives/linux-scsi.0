From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: gdth oops
Date: Sun, 04 May 2008 22:33:24 -0500
Message-ID: <1209958404.16283.36.camel@localhost.localdomain>
References: <263955236@web.de>
	 <1209922371.16283.33.camel@localhost.localdomain>
	 <008501c8ae3f$e0b32a70$6400a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51511 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYEEDd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 23:33:28 -0400
In-Reply-To: <008501c8ae3f$e0b32a70$6400a8c0@bui.materna.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland <devzero@web.de>
Cc: achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-05-05 at 01:37 +0200, Roland wrote:
> Hi James,
> 
> >So, try this as the fix.
> >
> >James
> 
> thanks!
> 
> i`d like to report that your patch resolves the reported issues.

Great, thanks.  I'll send it as two patches, since fixing the PCI driver
problem uncovered another one with the timers.

James


