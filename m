From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Wed, 19 Oct 2005 17:40:33 -0400
Message-ID: <1129758034.9618.14.camel@mulgrave>
References: <20051015013824.GA25248@linux-mips.org>
	 <20051017104312.GB22710@infradead.org>  <43538988.3000204@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39132 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751368AbVJSVkx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 17:40:53 -0400
In-Reply-To: <43538988.3000204@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, Christoph Hellwig <hch@infradead.org>

On Mon, 2005-10-17 at 21:22 +1000, Douglas Gilbert wrote: 
> Is there any such policy?

Yes, there is.  It's not actually mine, it's the direction coming out of
several kernel summits.  /proc is to be moved back to handling process
information. /sys should be used for other ancillary information
exporting.

This policy can be interpreted with some elasticity depending on what an
author wants to do.

> Christoph Hellwig previously has used this purported policy
> to reject scsi procfs bug fixes:
> "[PATCH] scsi: /proc/scsi/scsi patch for large number of devices"
> As for alternate tools to 'cat /proc/scsi/scsi', I
> am not aware of many distributions using lsscsi (debian
> and gentoo do), perhaps there are other tools. I
> suspect a lot of folks are still using 'cat /proc/scsi/scsi'.

/proc/scsi/scsi has an awful lot of failure cases.  The most annoying
one seems to be periodically losing hot added devices.

The reason for not fixing something if it's not a severe bug is simply
that if we keep /proc/scsi/scsi fully functional and up to date, then
the distributions will have no incentive to move away from it.

> Does Christoph Hellwig have the right to NACK/veto
> etc work that is not his when you are the SCSI maintainer?

Technically no-one truly gets a veto since there are many ways code can
end up in the vanilla kernel; however, everyone gets to express their
opinion ...

James


