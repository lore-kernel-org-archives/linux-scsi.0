From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Thu, 12 Jul 2007 13:57:50 -0700
Message-ID: <20070712135750.2a4a4a54.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:49022 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759830AbXGLUx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 16:53:56 -0400
Received: from midway.site ([71.117.236.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2007 13:53:56 -0700
In-Reply-To: <4695F76F.5000305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 12 Jul 2007 12:42:07 +0300 Boaz Harrosh wrote:

> In motivation for the !use_sg cleanup and use of accessors
> I needed to do some restructuring of the aha152x.c driver.
> 
> I have tried to be as careful as I could, but with out
> the hardware for testing, it is hard. Christoph and James
> You are signed on a couple of the last patches to this driver
> So you are probably somewhat familiar with the code. Could
> you please review the patchset to see that nothing is broken.
> 
> If any one has an Hardware that uses aha152x.c, please help me
> with testing this patchset. If it does not work could you please
> do a short bisect of which patch breaks out of the 4.

I could test it on PCMCIA.  However, the patches are against
the scsi-misc git tree, correct?  So I would have to clone
that git tree first...  that's not good.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
