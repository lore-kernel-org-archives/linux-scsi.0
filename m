From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: When the device task management functions get invoked
Date: Fri, 3 Jul 2009 15:10:13 +0530
Message-ID: <97a757510907030240v6860151cxc4584da3db711bfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:14771 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZGCJkK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2009 05:40:10 -0400
Received: by wa-out-1112.google.com with SMTP id j5so466599wah.21
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jul 2009 02:40:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I have implemented some Task Management Functions like abort_task in a
custom device driver for UASP. None of these functions get invoked at
any point of time. Could any one please let me know when can these
functions get invoked?

I have canceled the read/write operations from/to host to device or
vice-versa. Still, they did not get invoked.

However, the device is enumerated and all the operations are working
fine like read / write.

Thanks in advance.

With Regards,
Madhavi M
