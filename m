From: Andrew Morton <akpm@osdl.org>
Subject: Fw: aic79xx + tape 2.6.13.5 -> 2.6.15.4 problem
Date: Tue, 28 Feb 2006 23:19:47 -0800
Message-ID: <20060228231947.12cc7076.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:34484 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932598AbWCAHVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 02:21:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Frithjof Kruggel <fkruggel@uci.edu>



Begin forwarded message:

Date: Mon, 27 Feb 2006 18:45:56 -0800
From: Frithjof Kruggel <fkruggel@uci.edu>
To: linux-kernel@vger.kernel.org, fkruggel@uci.edu
Subject: aic79xx + tape 2.6.13.5 -> 2.6.15.4 problem


Sorry to bother you with this. I have a server
system equipped with an Adaptec U320 board,
attached a HP Ultrium 2 drive.
Since I upgraded from kernel version 2.6.13.5
to 2.6.15.4, tape write speeds dropped from
22 MB/s to 4.5 MB/s. Looks like asynchonous
write mode is now negotiated.
Any help is appreciated - please, cc to my
address above as I am not a regular reader.
Thanks,

Frithjof
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
