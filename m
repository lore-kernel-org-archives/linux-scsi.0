From: Tejun Heo <htejun@gmail.com>
Subject: Re: Support for (new?) Silicon Image PCI SATA controller
Date: Fri, 10 Nov 2006 08:37:23 +0900
Message-ID: <4553BBB3.1000508@gmail.com>
References: <200611081803.52986.wjl@icecavern.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:59199 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1161318AbWKIXhh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 18:37:37 -0500
Received: by ug-out-1314.google.com with SMTP id m3so382094ugc
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2006 15:37:36 -0800 (PST)
In-Reply-To: <200611081803.52986.wjl@icecavern.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wesley J. Landaker" <wjl@icecavern.net>
Cc: linux-scsi@vger.kernel.org, Carlos Pardo <Carlos.Pardo@siliconimage.com>

Hello, Wesley.

Wesley J. Landaker wrote:
> Hi folks,
> 
> I just obtained a new PCI SATA controller card that I was told was supported 
> by Linux, but it doesn't appear to match up with the expected device IDs I 
> see listed in the sata_sil or sata_sil24 drivers currently.
> 
> Does anyone have any knowledge about this device? e.g. is it a new Silicon 
> Image device, or perhaps I am mistaken and it's a really *old* one?
> 
> Here is the output of lspci -vvnn for the device, which captures as much info 
> as I know how to easily obtain. It would be really interested if someone 
> could tell me if this looks anything like a possible-to-support SI device, so 
> I know whether it's worth pursuing or not?
> 
> 00:10.0 Mass storage controller [0180]: Silicon Image, Inc. Unknown device 
> [1095:2502] (rev 01)
>         Subsystem: Silicon Image, Inc. Unknown device [1095:2512]

SIMG says there's no such device and it's probably bad hardware 
(probably a 3512) with stuck bits in PCI ID.  If you bought it, ask for 
replacement.

-- 
tejun
