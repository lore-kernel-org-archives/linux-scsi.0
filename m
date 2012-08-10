From: mangel <mazanx@gmail.com>
Subject: Linux 3.2: SCSI counters iodone_cnt and iorequest_cnt
Date: Fri, 10 Aug 2012 11:40:59 +0200
Message-ID: <CA+GPQo810GFw6Hd4+n-g7M2RspYEiBcYLJWbXUm82H9aE66j4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40944 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab2HJJlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2012 05:41:00 -0400
Received: by obbuo13 with SMTP id uo13so1990465obb.19
        for <linux-scsi@vger.kernel.org>; Fri, 10 Aug 2012 02:40:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

While trying out a Linux 3.2 kernel I've noticed that the counters
iodone_cnt and iorequest_cnt end up differing from each other after having
written a file to disk with dd. Iorequest_cnt > iodone_cnt even a long time
(several minutes) after the write is complete. The disk that was used for
the file is an SSD connected via SATA. A friend has tested writing a file
on his computer (running Debian wheezy with 3.1 kernel and on "rotating"
disk connected via SATA) and sees the same behaviour. Actually the
difference between the counters increases over time.

When doing a file write on an HDD connected via SAS, I don't see this
behaviour.
Is this a known behavior for SATA?

Best regards,
Magnus
