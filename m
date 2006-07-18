From: Andrew Morton <akpm@osdl.org>
Subject: Fw: gdth SCSI driver(?) fails with more than 4GB of memory
Date: Mon, 17 Jul 2006 18:46:59 -0700
Message-ID: <20060717184659.04ae83e7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25827 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750742AbWGRBrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jul 2006 21:47:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andreas Barth <aba@not.so.argh.org>



Begin forwarded message:

Date: Mon, 17 Jul 2006 13:00:56 +0200
From: Andreas Barth <aba@not.so.argh.org>
To: linux-kernel@vger.kernel.org
Subject: gdth SCSI driver(?) fails with more than 4GB of memory


[please Cc me, I'm currently not subscribed.]

Hi,

I have noticed that one of my boxes stopped to boot correctly after
adding more memory (in total 6 GB) and loading an adjusted kernel for
that.  After some testing around, we noticed that it is enough for the
kernel to boot correctly if we limit the kernel to use 4GB of memory.

If the kernel has 6GB, I directly get error messages like:
SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
sda: Write Protect is off
sda: got wrong page
sda: assuming drive cache: write through
SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
sda: Write Protect is off
sda: got wrong page

The disk array controller is of type GDT8114RZ and has the most current
firmware version. The box has 4 Xeon CPUs, and physical 6 GB of memory.
The /-device is on the controller in question.

The full log (for 4 and for 6 GB) is put up on
http://neualius.turmzimmer.net/~aba/6GB


Any hints for me how I can use the full 6 GB of memory (and/or what I
should try out to find the bug)?


Cheers,
Andi
-- 
  http://home.arcor.de/andreas-barth/
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
