From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: 20 May 2004 17:51:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085097107.3731.0.camel@patibmrh9>
References: <20040519081534.GE30348@suse.de><1084981551.3082.80.camel@patib
	mrh9>  <20040520080622.GF1952@suse.de><1085090500.3822.20.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:35037 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265312AbUETXv7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 19:51:59 -0400
In-Reply-To: <1085090500.3822.20.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

> ... inline below for your convenience.
> 
> Also I will install & reboot & look for trouble.

No trouble found, in the search quoted below.

Pat LaVarre

$ uname -r
2.4.27-pre3
$
$ sudo mkudffs /dev/hdc
...
$ sudo mkudffs /dev/scd0
...
$
$ sudo mount /dev/hdc /mnt/hdc
$ sudo mount /dev/scd0 /mnt/scd0
$ mount | grep mnt
/dev/hdc on /mnt/hdc type udf (rw)
/dev/scd0 on /mnt/scd0 type udf (rw)
$
$ sudo umount /dev/hdc /dev/scd0
$


