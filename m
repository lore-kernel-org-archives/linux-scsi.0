From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Disk simulator driver
Date: Sun, 29 Oct 2006 12:19:19 -0800
Message-ID: <1162153159.6802.21.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:20452 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S965400AbWJ2UTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 15:19:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Is there a project/driver that would take a disk/file/lvm partition as
an argument(/dev/sda, /tmp/my_big_file.bin /dev/Mapper/MYLVMPART eg.)
and then create a new /dev entry that could be read/written to as though
it were a disk?

I think I want to look at sg, but I wasn't sure if that is what I want.

Just poking around for fun and education.

Sean

