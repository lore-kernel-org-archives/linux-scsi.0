From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 07 Feb 2008 17:04:02 -0800
Message-ID: <1202432647.31361.26.camel@brick>
References: <1202432206.3171.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:6797 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYBHBEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 20:04:12 -0500
Received: by wx-out-0506.google.com with SMTP id h31so3885850wxd.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Feb 2008 17:04:11 -0800 (PST)
In-Reply-To: <1202432206.3171.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> Quite a bit of this is fixing things broken previously (the advansys fix
> is still pending resolution, but I'll send it as an -rc fix when we have
> it).  There's the final elimination of all drivers that are esp based
> but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> the usual bunch of driver updates and the addition of a new enclosure
> services driver and the corresponding ULD.
> 
> The patch is available from:
> 

I'm going to guess that this is the entry in feature-removal.txt
that need an update then:

---------------------------

What:	old NCR53C9x driver
When:	October 2007
Why:	Replaced by the much better esp_scsi driver.  Actual low-level
	driver can be ported over almost trivially.
Who:	David Miller <davem@davemloft.net>
	Christoph Hellwig <hch@lst.de>


Cheers,

Harvey

