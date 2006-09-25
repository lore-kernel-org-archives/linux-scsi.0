From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Subject: Re: [PATCH] scsi/mptsas: add RAID devices in ascending ID order
Date: Mon, 25 Sep 2006 11:59:29 +0200
Message-ID: <4517A881.3000903@fujitsu-siemens.com>
References: <664A4EBB07F29743873A87CF62C26D7032D5CF@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:8847 "EHLO
	dgate2.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S1750897AbWIYJ7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 05:59:37 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032D5CF@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer <mpt_linux_developer@lsil.com>

Hi Eric,

thanks for your response.

>>    The patch makes sure that arrays are added in ascending
>>    VolumeID order.
> 
> Rejected.  
> 
> Ascending ID ordering does not address all cases. 
> There is no guarantee which target ids are 
> assigned by firmware to volumes when
> volumes are created.  

That's what my patch was supposed to handle: No matter what the ordering 
of IDs by firmware is, the devices are registered in ascending ID order.

> I've made similar 
> ordering proposals before to this mailing list. 
> All been rejected.

Do you have a thread reference for me? I'd like to understand the 
arguments better. I find this strange because scanning in ascending 
order has always been the common case in drivers as well as in the mid 
layer, AFAIK.

> I suggest that you not map your devices
> to /dev/sda, but instead use persistent
> device labels or names.  Most distro's
> now days ship with Logical Volume Manager
> that does this for you.

I know it. The problem is that there are important distros out there 
that do support persistent device names and LVM, but don't enable them 
by  default. My patch was intended to implement the "principle of least 
surprise" for users of such distributions with little experience.
More so because mptspi and mptsas behave differently; the problem
I was talking about is currently only encountered with mptsas.

Regards,
Martin

-- 
Martin Wilck                Phone: +49 5251 8 15113
Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
Heinz-Nixdorf-Ring 1        mailto:Martin.Wilck@Fujitsu-Siemens.com
D-33106 Paderborn           http://www.fujitsu-siemens.com/primergy
