From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mptbase Code={Abort} (LSI SAS1068 PCI-X Fusion-MPT)
Date: Wed, 23 Apr 2008 07:28:45 +1200
Message-ID: <480E3C6D.5090604@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:60108 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146AbYDVT0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 15:26:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sebastian@wasilewski.name

I received a reply from LSI:

"It seems there is some bad cable or connectivity or bad device in the
topology. The loginfo 0x31123000 says the I/O is aborted due to a Stuck
Link. The loginfo 0x31120403 specifies the I/O is aborted due to frame
transfer errors."

So far doing large dd reads and writes, I have been unable to generate 
any of these errors, it is only during the initial md RAID5 sync up, so 
I guess this is going to be a little tricky to pin down.

Regards,

Richard
