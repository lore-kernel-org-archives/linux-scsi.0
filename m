From: John Smith <lenovomi@gmail.com>
Subject: btrfs - uknown issues - different sha256 hash - files corruption
Date: Sun, 24 Jan 2016 23:05:18 +0100
Message-ID: <CAAcrkYKQx5ctKW=WWtE4wwS0fAwvWxHz5s7fKyBLUHyjwVRo_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35699 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbcAXWFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jan 2016 17:05:49 -0500
Received: by mail-io0-f179.google.com with SMTP id 77so134584089ioc.2
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jan 2016 14:05:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear,

I have cubox-i4, running debian with 4.4 kernel. The icy box
IB-3664SU3 enclosure is attached into cubox using esata port,
enclosure uses JM393 and JM539 chipsets.

I use btrfs volume in raid0 created from the two drives, and lvm ext4
volume that contains two drives also. When I copy (using rsync) big
file (the one i copied is 130GB) from ext4 to btrfs the sha256 hash is
differs.

I did 2 tests, copy the source file from ext4 to btrfs, count sha256
hash, each time the destination file on btrfs has different hash
compared to the source file located on ext4 and even hashes from both
runs of target files on btrfs differs.

I run cmp -l <(hexdump source_file_ext4) <(hexdump target_file_btrfs).
The snapshot of the result is here http://paste.debian.net/367678/,
the is so many bytes with differences. The size of the source and
target file is exactly the same.


I also copied around 600GB of data set that contains small files,
music, videos, etc... and i did sha256 on all the files ext4 vs btrfs
- all was fine.

Any idea what can cause that issue or how can i debug it in more detail?


Thank you!

Best,
John
