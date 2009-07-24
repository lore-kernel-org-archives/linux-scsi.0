From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
Date: Fri, 24 Jul 2009 14:44:55 +0300
Message-ID: <4A699EB7.4030307@turknet.net.tr>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netone.net.tr ([193.192.98.182]:23754 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZGXLo4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2009 07:44:56 -0400
In-Reply-To: <4A69932E.90906@turknet.net.tr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

On 07/24/2009 01:55 PM, Tarkan Erimer wrote:
>
> Martin,
>
> Today, I had time to bisect and you were right: The below commit 
> related to capacity detection changes in SCSI subsystem,as you 
> mentioned, seems the cause of the problem.
>

Sorry, I was confused when replying. The introduced bug is not because 
of the "Capacity Detection Changes In SCSI Subsystem." commit; because 
of "sd: Detect non-rotational devices" commit. It seems I need more 
coffee ;-)
One more time sorry for my stupidity :-)


> 3821d768912a47ddbd6cab52943a8284df88003c is first bad commit
> commit 3821d768912a47ddbd6cab52943a8284df88003c
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Sat May 23 11:43:38 2009 -0400
>
>     sd: Detect non-rotational devices
>
>     Detect non-rotational devices and set the queue flag accordingly.
>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>     Signed-off-by: James Bottomley 
> <James.Bottomley@HansenPartnership.com>
>
> :040000 040000 f744f08d73f56e6d8461267c8c5bc4c710d4c9dd 
> 89eb1f56a7066a22a9ae6b7b916453a78a9dd082 M      drivers
>
>

