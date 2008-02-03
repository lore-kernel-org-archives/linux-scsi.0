From: Andrew Morton <akpm@linux-foundation.org>
Subject: dmesg spam
Date: Sun, 3 Feb 2008 14:30:33 -0800
Message-ID: <20080203143033.cfea0501.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYBCWa1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 17:30:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


With latest -mm, running fc8 I am getting this in the logs,
once per second.

sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
sr0: CDROM not ready.  Make sure there is a disc in the drive.
