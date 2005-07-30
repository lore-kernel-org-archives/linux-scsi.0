From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Sun, 31 Jul 2005 01:15:41 +0200
Message-ID: <42EC0A1D.1090008@s5r6.in-berlin.de>
References: <42E29DF5.5090603@s5r6.in-berlin.de> <42E2A15A.2030609@s5r6.in-berlin.de> <20050726042640.GA17885@phunnypharm.org> <42EBF6A2.7040305@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:10956 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S263186AbVG3XP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 19:15:58 -0400
In-Reply-To: <42EBF6A2.7040305@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

I wrote:
> According to dmesg with SBP2_DEBUGs enabled,
> scsi_remove_device() is entered but sbp2_logout_device() not.
> IOW scsi_remove_device() is not completed.

Another evidence of this is that "Synchronizing SCSI cache for
disk sda:" appears again when I shut the system down.

>> Perhaps you can turn on spinlock debug

Turns up nothing. I will dig through scsi_remove_device() but
it may take me a while to become accustomed with it.
-- 
Stefan Richter
-=====-=-=-= -=== =====
http://arcgraph.de/sr/
