From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: bad refcount of the sdev when using scsi_device_add
Date: Mon, 17 Oct 2005 08:43:27 +0200
Message-ID: <4353480F.5070108@s5r6.in-berlin.de>
References: <B9FFC3F97441D04093A504CEA31B7C41591BB7@msilexch01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33188 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932142AbVJQGpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 02:45:13 -0400
In-Reply-To: <B9FFC3F97441D04093A504CEA31B7C41591BB7@msilexch01.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Saeed Bishara <saeed@marvell.com>

Saeed Bishara wrote:
> I found that the flow of adding device using scsi_scan_target ends
> with different refcount of the sdev than using the scsi_add_device,
> in the former one the refcount is less by 1. the scsi_scan_target
> calls scsi_device_put, but there is no analogous put in the
> scsi_add_device function.

This was changed in Linux 2.6.14-rcX:
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=146f7262ee0ec7fc6882f06e5fcb13883308073c
The commit log also tells how to properly use scsi_add_device() before 
and after that change.
-- 
Stefan Richter
-=====-=-=-= =-=- =---=
http://arcgraph.de/sr/
