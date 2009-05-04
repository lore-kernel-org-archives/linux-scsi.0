From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux doesn't support bigger than 2TB IEEE-1394 disk
Date: Mon, 04 May 2009 16:49:34 +0200
Message-ID: <49FF007E.5090108@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw> <49FEFF7A.3090603@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45834 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZEDOtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 10:49:50 -0400
In-Reply-To: <49FEFF7A.3090603@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ronald <Ronald@ioi.com.tw>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> do you know of a specific series of SBP-2 firmwares which do 
> actually support READ CAPACITY (16) properly but are treated by Linux as 
> if they wouldn't?  If so, we could add a workaround to our drivers to 
> treat them like recent SBC implementations.  We would have to match 
> against their firmware_revision field which you get logged in dmesg if 
> you load the sbp2 or firewire-sbp2 driver with the module parameter 
> workarounds=0x1000.

PS:

# modprobe -r sbp2
# modprobe sbp2 workarounds=0x1000
(plug the disk in, wait 5 or 10 seconds or so)
# dmesg

Use firewire-sbp2 instead of sbp2 if your distribution already uses the 
newer firewire drivers which are alternatively available in recent 
kernel versions.  E.g. on Fedora.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
