From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 17:07:12 +0200
Message-ID: <42D139A0.4030207@s5r6.in-berlin.de>
References: <42D133EE.9090204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50870 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261954AbVGJPHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 11:07:48 -0400
In-Reply-To: <42D133EE.9090204@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: Ben Collins <bcollins@debian.org>

I wrote:
> So I just added a few more scsi_host_put() to sbp2_remove_device(). 
> scsi_eh_# now goes away when I disconnect the device. Still, modprobe -r 
> sbp2 fails with "FATAL: Module sbp2 is in use.".

I also added printks and according to them, shost_gendev.release is 
called after scsi_host_put is entered for the fourth time in 
sbp2_remove_device.
-- 
Stefan Richter
-=====-=-=-= -=== -=-=-
http://arcgraph.de/sr/
