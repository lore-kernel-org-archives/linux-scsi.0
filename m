From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qlogicpti: use request_firmware
Date: Sat, 10 Jan 2009 17:30:39 -0600
Message-ID: <1231630239.3642.56.camel@localhost.localdomain>
References: <1231600926.5806.131.camel@macbook.infradead.org>
	 <1231603097.3642.25.camel@localhost.localdomain>
	 <1231615150.5806.137.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41464 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbZAJXan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 18:30:43 -0500
In-Reply-To: <1231615150.5806.137.camel@macbook.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, jaswinder@infradead.org

On Sat, 2009-01-10 at 19:19 +0000, David Woodhouse wrote:
> On Sat, 2009-01-10 at 09:58 -0600, James Bottomley wrote:
> > I'm assuming this fixes the open firmware conversion bug?
> 
> Which bug was that?

This one:

Subject: 	linux-next: scsi tree build failure
Date: 	Wed, 31 Dec 2008 03:16:39 +1100 (Tue, 10:16 CST)


Hi James,

Today's linux-next build (sparc defconfig) failed like this:

drivers/scsi/qlogicpti.c: In function 'qlogicpti_load_firmware':
drivers/scsi/qlogicpti.c:480: error: 'struct qlogicpti' has no member
named 'sdev'

An interaction between commit 68175399c8b5ee90960e78c1bb8e3353e71fbf33
("[SCSI] qlogicpti: use request_firmware") from the scsi tree and commit
5dc2536bb8d8adb5fdfbe76cd6fdcdf9de3f40f8 ("qlogicpti: Convert to pure OF
driver") which is in Linus' tree.

The version of the firmware commit that has been in the firmware tree
since Nov 19 has this conflict corrected.

I have left it for today (as it is getting way to late).  Please fix it
up for tomorrow.

