From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: usage of max_sectors in scsi_host_template
Date: Tue, 06 Nov 2007 19:32:57 +0100
Message-ID: <4730B359.8020806@s5r6.in-berlin.de>
References: <47304E70.9090005@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38923 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbXKFSc7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 13:32:59 -0500
In-Reply-To: <47304E70.9090005@Voltaire.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@Voltaire.COM>
Cc: linux-scsi@vger.kernel.org

Erez Zilber wrote:
> I'm not sure that I understand the meaning of max_sectors in 
> scsi_host_template.

Did you have a look at scsi_mid_low_api.txt?
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/scsi/scsi_mid_low_api.txt;h=6f70f2b9327e1f0db7bc05bdbf2d6ce3b2fcbdcf#l1232

> Is it the maximum data length of a single SCSI command?

Yes.

> Is it in bytes?

No, it is in units of 512 bytes.

> What's the size of a sector?

"Usually" 512 bytes according to above doc.  Always 512 bytes from the
point of view of block/ll_rw_blk.c::blk_queue_max_sectors().
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=block/ll_rw_blk.c;h=75c98d58f4ddf7252e2717e0924b9d6a8925b4e5#l590
-- 
Stefan Richter
-=====-=-=== =-== --==-
http://arcgraph.de/sr/
