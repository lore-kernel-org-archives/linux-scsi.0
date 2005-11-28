From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.15-rc2: oops after abortion of SCSI inquiry
Date: Mon, 28 Nov 2005 20:56:54 +0100
Message-ID: <438B6106.3070709@s5r6.in-berlin.de>
References: <438832A0.7000309@s5r6.in-berlin.de> <20051128190457.GH20781@conscoop.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48808 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932224AbVK1T6c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 14:58:32 -0500
In-Reply-To: <20051128190457.GH20781@conscoop.ottawa.on.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jody McIntyre <scjody@modernduck.com>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Jody McIntyre wrote:
> Did you try the patch I posted 3 weeks ago?  It's now in Linus's tree
> but did not make it to -rc2.
> 
> http://kernel.org/git/?p=linux/kernel/git/scjody/ieee1394.git;a=commit;h=963f48a116bf3b797fe184e74c79c50de1da70bb
> 
> Without looking too deeply into your oops, it looks like the same root
> cause: not taking sbp2_command_orb_lock, leading to corrupted
> sbp2_command_orb_inuse and an eventual oops.

I am quite certain that when I first saw the oops I had all post-2.6.14 
ieee1394 updates applied, i.e. the sbp2_command_orb_lock fix too. It 
happened the same way with and without these ieee1394 updates.
-- 
Stefan Richter
-=====-=-=-= =-== ===--
http://arcgraph.de/sr/
