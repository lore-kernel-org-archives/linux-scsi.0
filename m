From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Sat, 17 Jan 2009 14:17:23 -0700
Message-ID: <20090117211723.GB30719@parisc-linux.org>
References: <1232117771.3224.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39100 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbZAQVRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Jan 2009 16:17:30 -0500
Content-Disposition: inline
In-Reply-To: <1232117771.3224.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, Jan 16, 2009 at 09:56:11AM -0500, James Bottomley wrote:
>       mpt fusion: Add separate msi enable disable for FC,SPI,SAS

I thought we rejected this one as being completely bogus?  I certainly
don't remember seeing even an excuse for it after I challenged it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
