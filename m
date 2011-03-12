From: Arne Jansen <lists@die-jansens.de>
Subject: reusing bios
Date: Sat, 12 Mar 2011 10:29:20 +0100
Message-ID: <4D7B3CF0.5040102@die-jansens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:49515 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1CLJ3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2011 04:29:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk

Hi,

I'm trying to re-use struct bio after completion, including the
allocated pages. Normally I re-initialize the fields bi_sector,
bi_size, bi_next, bi_flags, bi_comp_cpu and bi_bdev.
This works perfectly well, as long as no media errors are encountered.
After a media error, all subsequent reads with this bio fail. Are
there any more fields that need to get re-initialized? Or, better,
is there a function to reset the bio?

Thanks,
Arne
