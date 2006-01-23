From: Ariel <askernel2615@dsgml.com>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Sun, 22 Jan 2006 21:14:40 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz>
 <1137917798.3328.2.camel@laptopd505.fenrus.org>  <1137918044.3328.6.camel@laptopd505.fenrus.org>
  <Pine.LNX.4.62.0601221251340.30208@pureeloreel.qftzy.pbz>
 <1137956841.3328.36.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([63.240.77.82]:33460 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S1751387AbWAWCOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 21:14:52 -0500
In-Reply-To: <1137956841.3328.36.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Sun, 22 Jan 2006, Arjan van de Ven wrote:
>>> On Sun, 2006-01-22 at 09:16 +0100, Arjan van de Ven wrote:
>>>> On Sat, 2006-01-21 at 21:13 -0500, Ariel wrote:

>>>>> I have a memory leak in scsi_cmd_cache.

>>>> does this happen without the binary nvidia driver too? (it appears
>>>> you're using that). That's a good datapoint to have if so...

> please repeat this without nvidia ever being loaded. Just having a
> module loaded before can already cause corruption that ripples through
> later, so just unloading is not enough to get a clean result.

I rebooted without nvidia or vmware ever being loaded and got a 
leak of 1.12KB/s. So I think we can rule that out.

A commonality I'm noticing is SATA. SATA had a big update in this 
version, so perhaps that's where to start looking.

 	-Ariel
