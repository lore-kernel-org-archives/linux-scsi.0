From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: rmmod qlogic driver stuck
Date: Mon, 8 Dec 2008 09:23:39 -0800
Message-ID: <9BECC90A-21CB-4600-A6F9-9ABEAEB48839@qlogic.com>
References: <1228736014.6291.221.camel@galr-linux.storwiz.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:23239 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYLHRXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 12:23:42 -0500
In-Reply-To: <1228736014.6291.221.camel@galr-linux.storwiz.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com


On Dec 8, 2008, at 3:33 AM, Gal Rosen wrote:

> Hi,
>
> I am working against IBM Total Storage DS4000 with LSI INF-01-00 Rev:
> 0534 controller. First I don't understand why this controller  
> present 32
> access LUNs instead of one.
>
> But my main issue is when I create virtual port and then try to rmmod
> the qlogic driver, it stuck. I must say that I made changes to the
> qlogic driver which add possibility to create virtual port in FC-AL
> topology. The base driver is from kernel 2.6.26.2.
>
> Here is a part of the messages file:
>
> [ 1814.053285] scsi(7): DPC handler exiting
[snip]
>
> host5 is the physical port, and host8 is the virtual port that created
> on host5.
> This issue does not occur against CLARiiON for instanse.
As you may know, the NPIV feature implemented in such a way to work only
in switched fabric topology.
It requires certain switch with NPIV capable to be able to make the
feature fully working.

Thank you,
Seokmann

>
>
> Please help !!!
>
> Thanks,
> Gal Rosen.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

