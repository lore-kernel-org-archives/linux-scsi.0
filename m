From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Wed, 15 Jul 2009 10:46:52 +0300
Message-ID: <4A5D896C.80107@turknet.net.tr>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netone.net.tr ([193.192.98.182]:42820 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZGOHqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 03:46:54 -0400
In-Reply-To: <yq1fxdji03l.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On 06/29/2009 05:30 PM, Martin K. Petersen wrote:
>>>>>> "Tarkan" == Tarkan Erimer<tarkan.erimer@turknet.net.tr>  writes:
>>>>>>              
> Tarkan>  version=0x00 [no conformance claimed]
>
> Wow, that's super lame.  And somewhat odd because WDC are usually pretty
> good at USB-SATA bridge protocol compliance.  But in any case this is
> unrelated to your problems.
>
> My concern was that our recent changes to the capacity detection in SCSI
> failed for your device.  However, given your attached log it looks like
> it's a USB issue.  And rereading your original log it also looks like
> you had a USB timeout which coincided with READ CAPACITY failing.
>
> So I'm deferring to the USB folks.
>
> Tarkan>  [160848.805027] usb 5-8: reset high speed USB device using
> Tarkan>  ehci_hcd and address 7
>
>    

Hi again,

Any update for this issue ? This bug still exist in Linux-2.6.31-rc3.
Thanks,

Tarkan




