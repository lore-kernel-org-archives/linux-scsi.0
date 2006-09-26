From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi_scan_host will hang up my system!
Date: Tue, 26 Sep 2006 09:28:48 +0200
Message-ID: <4518D6B0.1030003@s5r6.in-berlin.de>
References: <20060926033733.30229.qmail@web18311.mail.tpe.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43935 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750716AbWIZH32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 03:29:28 -0400
In-Reply-To: <20060926033733.30229.qmail@web18311.mail.tpe.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: crazyrushstar@yahoo.com.tw
Cc: linux-scsi@vger.kernel.org

Please reply to the list, not in private.

crazyrushstar@yahoo.com.tw wrote:
> Now I have make my driver work well under a
> environment without a lun(This is a RAID card). After
> insmod , inquery(12H) , report lun(A0H) received 8
> times. Syetem   is alive.
> 
> If I insmod after make a lun, system will hangup
> within 2 secends. All message printed by printk wont
> show so that I dont know where is wrong.
> 
> I Use  "tail -f /var/log/messages &" to observe kernel
> log.
...

Probably an interrupt handler is hanging.

Set up a serial console or netconsole or debug via FireWire.

Or simply switch to a text console (IOW to a VGA console or framebuffer
console, not an X11 terminal) and let klogd log directly to it. This may
give you at least parts of the last messages. I think it goes like this:
# killall klogd
# klogd
# modprobe yourmodule

-- 
Stefan Richter
-=====-=-==- =--= ==-=-
http://arcgraph.de/sr/
