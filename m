From: Theodore Ts'o <tytso@mit.edu>
Subject: UAS driver seems to be reporting a 4k sector size for a 512 byte
 sector device?
Date: Mon, 26 Sep 2016 12:19:26 -0400
Message-ID: <20160926161926.cmayrily476v3wa7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33682 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750754AbcIZQUa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 12:20:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

Hi, I have a Samsung 850 Pro SSD which is currently in a USB 3.0 / UAS
external enclosure.  The Samsung SSD uses a 512 byte physical and logical
sector size, and when it is accessed via the usb-storage device, this
is what I get.

In a vain hope that I could get discard working, I built a kernel that
included the uas driver, and discovered that when I accessed the drive
using the uas driver, it showed up as a 4k physical sector device, and
this caused device-mapper to complain that the dm-crypt partition was
misaligned.

Is this a problem with the hardware, or with the UAS driver?

						- Ted
