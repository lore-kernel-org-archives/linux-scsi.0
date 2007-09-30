From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC 0/16] gdth combined patchset & call for testers
Date: Sun, 30 Sep 2007 17:00:32 -0400
Message-ID: <47000E70.8090204@garzik.org>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56651 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXI3VBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 17:01:05 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> [8/16] gdth: Remove virt hosts - Christoph && Boaz
>   Here we need an executive decision! The issue is as stated by Christoph:
> 
>     "The virt_ctr option allows to register a new scsi_host for each bus
>     on the raid controller.  This non-default option makes no sense with
>     the current scsi code and prevents cleaning up the host registration,
>     so remove it."
> 
>   I agree. This is just exactly the same as done buy scsi-ml scans but only
>   more resource consuming. Unless I'm totally missing something, perhaps it is
>   just a leftover from old kernels.
> 
>   But if it is decided that this "virt_ctr" fixture is absolutely needed than
>   I have a patch for re-enabling it at: "after the patchset", done in a different
>   way. Because for now it prevents the cleanups I need.
> 
>   Also this patch can Just be merged with [7/16] but I wanted it separate in the 
>   case we decide for "virt_ctr" fixture return.


I definitely agree too (that virt_ctr should go away).

My only worry is that this breaks somebody in the field.  Given that it 
is apparently a non-default option, I think that worry can be overlooked.

	Jeff


