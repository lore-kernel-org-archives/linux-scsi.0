From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Wed, 19 Aug 2009 11:22:01 +0300
Message-ID: <4A8BB629.2090207@panasas.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>	 <4A8A608D.9000909@panasas.com>	 <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>	 <4A8A7BB4.90102@panasas.com>	 <97a757510908180335u5c5f85b3r7d235440ba83c2cd@mail.gmail.com>	 <4A8A94A3.9010802@panasas.com> <97a757510908180642l48966e58g7c7705d2df60ccbc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:40549 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZHSIWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2009 04:22:04 -0400
Received: by fxm28 with SMTP id 28so3922120fxm.17
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2009 01:22:05 -0700 (PDT)
In-Reply-To: <97a757510908180642l48966e58g7c7705d2df60ccbc@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhavi Manchala <madhavi.lscsi@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 08/18/2009 04:42 PM, Madhavi Manchala wrote:
> On Tue, Aug 18, 2009 at 5:16 PM, Boaz Harrosh<bharrosh@panasas.com> wrote:
> 
> Dear Boaz,
> 
> Thanks again for the information.
> 
>> No!. You miss understood. iscsi is just a scsi LLD (Low Level Driver)
>> just as usb/storage/scsiglue.c is an LLD. You only register with scsi.
>>
>> scsi-ml has full support for bidi. Only the LLDs do not. except two
>> LLDs: iscsi and scsi_debug.
> 
> I guess, iscsi you are referring to is nothing but
> drivers/scsi/iscsi_tcp.c. If so, do I need to modify
> drivers/usb/storage/scsiglue.c file in a way to handle bidirectional
> commands. The reference code for the modification is iscsi_tcp.c file.
> 

Yes
and also drivers/scsi/scsi_debug.c

> Please let me know whether my assumption is correct or not.
> 
> Thanks and Regards,
> Madhavi M.

Good luck
Boaz
