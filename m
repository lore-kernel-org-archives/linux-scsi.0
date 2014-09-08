From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: I/O path cleanup
Date: Mon, 08 Sep 2014 09:22:40 +0200
Message-ID: <540D5940.8070900@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:43190 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaIHHWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 03:22:42 -0400
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> This series cleans up a couple of lose ends I noticed during the scsi-mq
> work, but which weren't important enough to address during the last cycle.

Hello Christoph,

Is there perhaps a public git tree available with this patch series ? I 
have tried to apply these patches on top of v3.17-rc4 but unfortunately 
without success:
$ git checkout v3.17-rc4 -b scsi-core-cleanup
$ for p in \[PATCH\ *; do echo ==== $p && git am -C1 "$p" || break; done
==== [PATCH 1_8] scsi: don't use scsi_next_command in 
scsi_reset_provider - Christoph Hellwig <hch@lst.de> - 2014-09-07 1831.eml
Applying: scsi: don't use scsi_next_command in scsi_reset_provider
==== [PATCH 2_8] scsi: remove scsi_next_command - Christoph Hellwig 
<hch@lst.de> - 2014-09-07 1831.eml
Applying: scsi: remove scsi_next_command
==== [PATCH 3_8] scsi: clean up S_G table freeing - Christoph Hellwig 
<hch@lst.de> - 2014-09-07 1831.eml
Applying: scsi: clean up S/G table freeing
/home/bart/software/linux-kernel/.git/rebase-apply/patch:138: trailing 
whitespace.

Context reduced to (1/1) to apply fragment at 640
Context reduced to (2/2) to apply fragment at 646
warning: 1 line adds whitespace errors.
==== [PATCH 4_8] scsi: stop passing a gfp_mask argument down the command 
setup path - Christoph Hellwig <hch@lst.de> - 2014-09-07 1831.eml
Applying: scsi: stop passing a gfp_mask argument down the command setup path
==== [PATCH 5_8] scsi: move scsi_dispatch_cmd to scsi_lib.c - Christoph 
Hellwig <hch@lst.de> - 2014-09-07 1831.eml
Applying: scsi: move scsi_dispatch_cmd to scsi_lib.c
error: patch failed: drivers/scsi/scsi.c:626
error: drivers/scsi/scsi.c: patch does not apply
Patch failed at 0001 scsi: move scsi_dispatch_cmd to scsi_lib.c
The copy of the patch that failed is found in:
    /home/bart/software/linux-kernel/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Bart.

