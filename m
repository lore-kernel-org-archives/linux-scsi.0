From: Andrew Morton <akpm@osdl.org>
Subject: Fw: SG_GET_ACCESS_COUNT ioctl problem
Date: Mon, 9 Jan 2006 22:49:02 -0800
Message-ID: <20060109224902.74fc3d94.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19120 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750857AbWAJGtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 01:49:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Hounschell <dmarkh@cfl.rr.com>



Begin forwarded message:

Date: Sun, 08 Jan 2006 08:45:26 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: SG_GET_ACCESS_COUNT ioctl problem


In the 2.4 kernel (not using devfs) the SG_GET_ACCESS_COUNT ioctl to an
sg device would report the correct/expected usage count when issued to a
sd disc that was mounted, accounting for the mount by the system. The
2.6 kernel does not. Is this now the expected behavior or is this a bug?

Mark
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
