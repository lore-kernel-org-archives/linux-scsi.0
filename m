From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 22:39:22 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4147AB5A.4060804@rtr.ca>
References: <41471163.10709@rtr.ca>  <414723B0.1090600@pobox.com> <1095186343.2008.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1095186343.2008.29.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

 >Actually, its only wrong in queuecommand because that can be called in
 >softirq context.
 >
 >Sleeping in the eh paths is fine (as long as you drop the locks that the
 >EH thread has uselessly taken for you).

Good, that's how I understood it as well.

But the locking is certainly a mess as-is in the QStor driver.
Sure, it is actually all technically correct, but hard to follow.

I believe I can remove nearly all of it and really tidy things up
as a result.

Thanks guys, this has been really helpful so far.
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
