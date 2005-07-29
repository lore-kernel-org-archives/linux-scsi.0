From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: sdparm cannot start or stop SATA disks
Date: Fri, 29 Jul 2005 18:02:24 +0200
Message-ID: <42EA5310.5070606@danbbs.dk>
References: <42EA0957.9010408@torque.net>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:45349 "EHLO
	pfepa.post.tele.dk") by vger.kernel.org with ESMTP id S262641AbVG2P6N
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 11:58:13 -0400
In-Reply-To: <42EA0957.9010408@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net

Douglas Gilbert wrote:
> Putting this post on this list might head off
> more (private) emails on this subject.
> 
> sdparm uses the START STOP UNIT SCSI command to start
> and stop (spin up and spin down) SCSI devices.
> Currently libata does not implement that SCSI command.
> [Hopefully Jeff contradicts me.]
> 
> Has anybody seen a USB or 1394 enclosure that implements
> START STOP UNIT? [The command is defined in SBC, MMC and
> RBC.]

Hi Douglas,
After our previous discussion on USB/Firewire start/stop, I asked on our 
dk LUG for info on external interfaces, but found none that seems to 
implement the needed SCSI functionality.
Too bad, would've been great being able to spin an external drive 
down/up as needed.

I think I read somewhere that one ATA disk (HItachi og Fujitsu) can do 
something similar automatically (i.e. adhering to a timeout), once 
configured to do so, using MS-based utils.
Dunno if those/similar are available for *nix.

-- 
Kind regards,
Mogens Valentin


2.6.12 rocks. I love the Conservative governor (not Arnold)..
   -- bird603568, on linuxquestions.org

