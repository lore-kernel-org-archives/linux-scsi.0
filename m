From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Tue, 30 Mar 2004 13:51:15 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040330035115.GA3680@twibble.org>
References: <20040327161034.GA9963@twibble.org> <200403282303.02146.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:60078 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262378AbUC3DvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 22:51:20 -0500
Content-Disposition: inline
In-Reply-To: <200403282303.02146.andrex@alumni.utexas.net>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Sun, Mar 28, 2004 at 11:03:02PM -0500, Andrew Schulman wrote:
[...]
> Tried it with 2.6.5-rc2.  Now 'modprobe dc395x' hangs (though without all of 
> the 'sg_to_virt failed' messages) as the drive keeps spinning.  'reboot' also 

Yeah, it's no longer getting to where you were having problems previously.

> eventually hangs, and again I need to hit the case reset button to get back 
> to normal.  syslog shows "Unable to handle kernel NULL pointer dereference"-- 
> see excerpt below.  I'll try the debugging and send you a log soon.

This is an unrelated problem. It's something to do with scsi tape sysfs
support and it looks like a fix for this problem went in just after
2.6.5-rc2 was released (patch-2.6.5-rc2-bk2.bz2).

So you could wait for 2.6.5-rc3/2.6.5 to be released, upgrade to
2.6.5-rc3-bkx (where bkx is a bk snapshot with x >=2), or go back to the
kernel you were using previously but copy the drivers/scsi/dc395x.c and
drivers/scsi/dc395x.h from the 2.6.5-rc2 kernel into it.

-- 
 Jamie Lenehan <lenehan@twibble.org>
