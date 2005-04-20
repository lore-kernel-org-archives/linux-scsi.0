From: Dheeraj Pandey <dheeraj@gmail.com>
Subject: writev to scsi disks
Date: Wed, 20 Apr 2005 08:01:53 -0700
Message-ID: <363f92a8050420080112dec5db@mail.gmail.com>
Reply-To: Dheeraj Pandey <dheeraj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.205]:5424 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261641AbVDTPBy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 11:01:54 -0400
Received: by rproxy.gmail.com with SMTP id a41so126863rng
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 08:01:54 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I was wondering if I did a simple writev to a SCSI disk, does it take
the sg path to the device? I am guessing sg (REQ_SPECIAL) is only
true for character devices (and ioctl's) and not block devices.

These are my questions:
  - Is sg a common feature among SCSI disks these days? How do I know
what disks support this feature (any capabilities published by the driver)?
  - How does one make writev work for SCSI disk (as a block device)
in direct_io?
  - If I use SCSI disks as character device, can I simply use writev on the
character device file, and will sg codepath be taken?
