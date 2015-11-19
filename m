From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [BISECTED] v4.4-rc1 SCSI disk init crash
Date: Thu, 19 Nov 2015 13:04:10 -0800
Message-ID: <564E394A.7060705@sandisk.com>
References: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
 <564E28DE.6010200@sandisk.com>
 <1447963712.2234.31.camel@HansenPartnership.com>
 <20151119202953.GE18138@blackmetal.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0096.outbound.protection.outlook.com ([207.46.100.96]:19040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934121AbbKSVER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 16:04:17 -0500
In-Reply-To: <20151119202953.GE18138@blackmetal.musicnaut.iki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11/19/2015 12:30 PM, Aaro Koskinen wrote:
> FYI, this sequence is 100% reproducible on my setup. The disk is in
> Macally USB enclosure. On cold-boot it will stay on "Spinning up disk"
> phase until I manually press the ON button. And that's when the disconnect
> message appears, don't know why...

Hello Aaro,

Can you check whether reverting only patch "block: don't release bdi 
while request_queue has live references" (commit 
b02176f30cd30acccd3b633ab7d9aed8b5da52ff) also makes the OCTEON router 
boot again ?

Thanks,

Bart.

