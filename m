From: Pankaj B <xpankajbx@gmail.com>
Subject: How to get scsi_device structure for /dev/sda
Date: Fri, 14 Oct 2011 09:59:43 +0530
Message-ID: <CALSejh5tmhtRLLni3mOGC3iCqJDy2rOgPxn2JVx7M3ni+FpR7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44242 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab1JNE3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2011 00:29:44 -0400
Received: by pzk1 with SMTP id 1so4471850pzk.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2011 21:29:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
Is it possible to get scsi_device structure for a disk attached to system?
There is a similar function "open_bdev_exclusive" that gives
block_device structure
for /dev/sda.


Thanks,
Pankaj
