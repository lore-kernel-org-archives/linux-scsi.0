From: David Jeffery <david_jeffery@adaptec.com>
Subject: Re: [PATCH 2.6] ips 2/2: minor fixes
Date: Thu, 15 Jan 2004 14:13:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074193981.607.51.camel@blackmagic>
References: <1074188494.607.20.camel@blackmagic>
	 <1074189041.1867.121.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48784 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262838AbUAOTJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 14:09:43 -0500
In-Reply-To: <1074189041.1867.121.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2004-01-15 at 12:50, James Bottomley wrote:
> I'll take this, but you are thinking about converting the driver away
> from /proc to sysfs, aren't you?
> 
> James

Yes, long term I do.  But not in the short term.

Going forward, this driver is intended to cover 2.6 and become the
source for future 2.4 driver updates.  As support for 2.4 fades, at some
point the 2.4 driver will split off and become critical fixes only. 
Until then, since sysfs doesn't exist in 2.4 I currently plan to keep
using proc with a unified driver instead of having to go ahead and split
2.4 and 2.6 and perform dual maintenance.

And I don't think anyone wants to add the sysfs code to a unified driver
and then #ifdef in the proc code for 2.4 and #ifdef in the sysfs code
for 2.6.  That would be the ugliest solution.

In summary, the current plan is to keep using the proc file for the next
few releases.  Once the 2.4 support goes into hard maintenance mode like
the rest of the 2.4 kernel, the plan is to replace the proc code with
sysfs.

David Jeffery

