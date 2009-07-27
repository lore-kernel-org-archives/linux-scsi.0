From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
Date: Mon, 27 Jul 2009 10:31:26 +0300
Message-ID: <4A6D57CE.3000108@turknet.net.tr>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr> <yq1hbwykj80.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.turknet.net.tr ([193.192.98.182]:53422 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbZG0Hb2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 03:31:28 -0400
In-Reply-To: <yq1hbwykj80.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On 07/27/2009 04:28 AM, Martin K. Petersen wrote:
>>>>>> "Tarkan" == Tarkan Erimer<tarkan.erimer@turknet.net.tr>  writes:
>>>>>>              
> Tarkan>  root@tarkane:~# sg_inq -e /dev/sdb
> Tarkan>  VPD INQUIRY: extended INQUIRY data page
> Tarkan>  inquiry: transport: Host_status=0x05 [DID_ABORT]
> Tarkan>  Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]
> Tarkan>      inquiry: failed, res=-1
>
> *sigh*
>
>
> sd: Avoid sending extended inquiry to legacy/broken devices
>
> Our existing check for VPD page validity does not handle devices that
> refuse to respond to INQUIRY with the EVPD bit set.
>
> Restrict extended inquiry to devices reporting SBC2/SPC3 or higher.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
>
>    

Martin,

Happily, I confirm that your patch worked flawlessly with -rc4! Thanks a 
lot for your help :-)

Cheers!

Tarkan

