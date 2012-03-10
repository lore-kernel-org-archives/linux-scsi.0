From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH V2] scsi_debug: add LBPRZ support
Date: Sat, 10 Mar 2012 19:47:15 +0100
Message-ID: <4F5BA1B3.7020704@interlog.com>
References: <4F57C061.9020807@redhat.com> <4F58049C.5010505@interlog.com> <4F584BCF.7030803@redhat.com> <yq1ty1zf60i.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40750 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2CJSrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Mar 2012 13:47:55 -0500
In-Reply-To: <yq1ty1zf60i.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: Eric Sandeen <sandeen@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>

On 12-03-08 04:48 PM, Martin K. Petersen wrote:
>>>>>> "Eric" == Eric Sandeen<sandeen@redhat.com>  writes:
>
> Eric>  note, I didn't change the return value of inquiry_evpd_b2(); that
> Eric>  seems unrelated to this change, and should be a separate patch,
> Eric>  no?
>
>
> scsi_debug: Fix incorrect page length in logical block provisioning VPD
>
> The page length for the 0xb2 VPD page is defined to be 4 bytes when no
> provisioning descriptors are provided (DP=0).
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
