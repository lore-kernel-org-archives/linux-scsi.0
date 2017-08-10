From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Thu, 10 Aug 2017 07:06:53 -0700
Message-ID: <1502374013.2736.11.camel@HansenPartnership.com>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
         <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
         <271fd4b5-046f-2c74-4af8-60f225744313@suse.de>
         <20170810070904.GA20910@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60842 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752497AbdHJOGz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 10:06:55 -0400
In-Reply-To: <20170810070904.GA20910@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2017-08-10 at 09:09 +0200, Christoph Hellwig wrote:
> No device support in Linux is unsupported, sorry.  I think we're
> getting into the corporate bullshit game a little too much here.

I think there are two different definitions of supported here.  To us,
any device to which the driver attaches is "supported".  However, if
it's never been tested before it may not work very well.  In the Linux
way, we'll try to fix the bugs when they're reported and in that sense
we support the device until nothing in the kernel attaches to its ids
anymore.

In the corporate world "supported" means we'll sell you a contract
giving you certain rights to report bugs and have us fix them.  There
are definite reasons why corporations only support a small range of new
devices, even though devices not on this list may still be attached to
by the driver and thus we (Linux Community) would try to fix the bug
reports for.

I think what you're basically asking for is a different name for the
flag, which is fine?  how about 'legacy' instead?

James
