From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 06 Oct 2003 16:14:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065478448.2361.1.camel@patehci2>
References: <1064847281.24854.2.camel@patehci2>
	 <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de>
	 <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2>
	 <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2>
	 <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2>  <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:47744 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261889AbTJFWOT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 18:14:19 -0400
In-Reply-To: <1065473899.6835.41.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

> diff -Nur linux-2.6.0-test5/include/scsi/scsi.h linux/include/scsi/scsi.h
> diff -Nur linux-2.6.0-test5/include/linux/cdrom.h linux/include/linux/cdrom.h
> diff -Nur linux-2.6.0-test5/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
> diff -Nur linux-2.6.0-test5/drivers/scsi/sr.c linux/drivers/scsi/sr.c

Trying that -test5 patch in -test6 I get:

patching file include/scsi/scsi.h
Hunk #1 succeeded at 74 (offset -7 lines).
patching file include/linux/cdrom.h
patching file drivers/cdrom/cdrom.c
Hunk #2 succeeded at 2465 (offset 9 lines).
patching file drivers/scsi/sr.c
Hunk #3 succeeded at 759 (offset -1 lines).

I will study this result and report back.

Pat LaVarre


