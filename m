From: Dheeraj Pandey <dheeraj@gmail.com>
Subject: writev to SCSI disks: Does sg work?
Date: Tue, 19 Apr 2005 16:09:40 -0700
Message-ID: <363f92a80504191609b2bc1e2@mail.gmail.com>
Reply-To: Dheeraj Pandey <dheeraj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.199]:61164 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261739AbVDSXJm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 19:09:42 -0400
Received: by rproxy.gmail.com with SMTP id a41so66642rng
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 16:09:40 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I was wondering if I did a simple writev to a SCSI disk, does it take
the sg path to the device? I am guessing this sg (REQ_SPECIAL) is only
true for character devices (and ioctl's) and not block devices.

These are my questions:
   - Is sg a common feature among SCSI disks these days? How do I know
what disks support this feature?
   - How does one make writev work for SCSI disk (as a block device)
in direct_io?
   - If I use SCSI disks as character device, can I use writev on the
character device file, and will sg codepath be taken?

Thanks
Dheeraj
