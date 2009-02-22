From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.29-rc5
Date: Sun, 22 Feb 2009 11:18:24 +0200
Message-ID: <49A11860.3000406@panasas.com>
References: <1235170927.9025.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:11919 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbZBVJSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 04:18:44 -0500
In-Reply-To: <1235170927.9025.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> This is a bunch of assorted bug fixes (with several in the qlogic
> drivers).
> 
> The patch is available at
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Andrew Vasquez (3):
>       qla2xxx: Update version number to 8.03.00-k3.
>       qla2xxx: Mask out 'reserved' bits while processing FLT regions.
>       qla2xxx: Properly acknowledge IDC notification messages.
> 
> Anirban Chakraborty (2):
>       qla2xxx: Correct slab-error overwrite during vport creation and deletion.
>       qla2xxx: Remove interrupt request bit check in the response processing pat
> 
> Brian King (3):
>       ibmvfc: Increase cancel timeout
>       ibmvfc: Fix rport relogin
>       ibmvfc: Fix command timeout errors
> 
> James Smart (1):
>       scsi_scan: add missing interim SDEV_DEL state if slave_alloc fails
> 
> Julia Lawall (1):
>       lpfc: introduce missing kfree
> 
> Martin Peschke (1):
>       sg: fix device number in blktrace data
> 
> Mike Christie (1):
>       libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out
> 
> Robert Jennings (1):
>       ibmvscsi: Correct DMA mapping leak
> 
> Shyam_Iyer@Dell.com (1):
>       qla2xxx: fix Kernel Panic with Qlogic 2472 Card.
> 
> 
> And the diffstat
> 
<snip>

James Hello.

Please, you must include a BUG fix patch I sent to the osd_uld, that was found
by users, with use of old osd-targets. (It was sitting in next for a while now)
It's an obvious BUG, no point of sending it the @stable way later.

http://www.spinics.net/lists/linux-scsi/msg33243.html

Do you need that I resend it?

Thanks in advance
Boaz
