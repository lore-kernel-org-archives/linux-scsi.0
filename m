From: Karthik Sarangan <karthiks@cdac.in>
Subject: Re: Re: accessing the scsi disk from a kernel module
Date: Fri, 30 Sep 2005 12:23:31 +0530
Message-ID: <433CE0EB.6040803@cdac.in>
References: <433CCCD2.3000003@cdac.in> <1e62d137050929230019fcbfb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.cdacindia.com ([203.199.132.35]:65221 "HELO
	mailx.cdac.ernet.in") by vger.kernel.org with SMTP id S1751419AbVI3HhX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 03:37:23 -0400
Received: from mailhub.cdac.in ([196.1.109.254])
 by mailx.cdac.ernet.in (SAVSMTP 3.1.0.29) with SMTP id M2005093013070204357
 for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 13:07:03 +0530
Received: from mailhub.cdac.in (mailhub [196.1.109.254])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j8U7Ylim032762
	for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 13:04:56 +0530
Received: from mailhub.cdac.in (mailhub [196.1.109.254])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j8U74kYb019184
	for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 12:34:53 +0530
Received: from mailhub.cdac.in (mailhub [196.1.109.254])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j8U6xa2E016671
	for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 12:29:37 +0530
In-Reply-To: <1e62d137050929230019fcbfb6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fawad Lateef <fawadlateef@gmail.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Fawad Lateef wrote:

>On 9/30/05, Karthik Sarangan <karthiks@cdac.in> wrote:
>  
>
>>what do I write in a kernel module for accessing a scsi disk device?
>>
>>    
>>
>
>What do u mean by this ??? Are you writing a driver for SCSI Disk or
>Want to do read/write on it using its own driver ??? For read/write
>using its own driver you can use/call generic_make_request (function
>from block/ll_rw_blk.c) from your kernel module to send requests to
>any block device available on the system and kernel will do the
>creating and sending request to correct block device whether that will
>be a SCSI disk or any disk .... And if you want directly to use the
>SCSI device then you have to make requests using SCSI protocol .....
>
>--
>Fawad Lateef
>
>  
>
I dont want the buffer cache of the block device interfering.

Basically I require to read/write data (without being cached or copied into
intermediate kernel buffers) to scsi disk from a kernel module.

Hope this make my meaning clearer.

Karthik Sarangan


