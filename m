From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: Problem with tape drive: illegal seek
Date: Sun, 27 Feb 2005 13:20:34 +0100
Message-ID: <200502271320.34864.chrivers@iversen-net.dk>
References: <200502260016.11954.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:50271 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S261379AbVB0MUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Feb 2005 07:20:51 -0500
Received: from localhost (localhost [127.0.0.1])
	by boreas.iversen-net.dk (Postfix) with ESMTP id 470801E91F4
	for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2005 13:20:32 +0100 (CET)
Received: from boreas.iversen-net.dk ([127.0.0.1])
	by localhost (boreas.iversen-net.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 28232-04 for <linux-scsi@vger.kernel.org>;
	Sun, 27 Feb 2005 13:20:28 +0100 (CET)
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2005 13:20:28 +0100 (CET)
In-Reply-To: <200502260016.11954.chrivers@iversen-net.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Thanks to you both!

Indeed, "dd" works when bs=10k, and tar works as long as you don't try to 
auto-compare it. I'll look into using --compare instead, thanks. 

I wonder if this is a bug or feature in tar? Should I report it?

-- 
Regards,
Christian Iversen
