From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Sat, 9 Feb 2008 05:45:11 -0700
Message-ID: <20080209124511.GB28967@parisc-linux.org>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain> <20080124003203.18871.52040.sendpatchset@localhost.localdomain> <1202151498.3096.84.camel@localhost.localdomain> <1202156151.13537.14.camel@linuxchandra> <1202156914.3096.112.camel@localhost.localdomain> <1202159970.13537.19.camel@linuxchandra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42580 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbYBIMpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 07:45:12 -0500
Content-Disposition: inline
In-Reply-To: <1202159970.13537.19.camel@linuxchandra>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, jens.axboe@oracle.com

On Mon, Feb 04, 2008 at 01:19:30PM -0800, Chandra Seetharaman wrote:
> The device does send these error messages currently, but it takes some
> time to get the check condition back, which adds up the time to boot
> especially when the # of LUNS is huge.
> 
> For example, in my test configuration, I had 40 luns, and the time
> difference (with this patch and without it) to boot is 171 seconds and
> 1426 seconds.

Was that with sync or async SCSI bus scanning?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
