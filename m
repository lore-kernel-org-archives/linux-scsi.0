From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: SAS Management Protocol (SMP) on Windows
Date: Mon, 22 Jul 2013 15:57:15 +0200
Message-ID: <51ED3A3B.7070708@gmail.com>
References: <loom.20130722T100620-437@post.gmane.org> <51ED370D.2060900@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59414 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3GVN4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jul 2013 09:56:30 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so2538972bkc.14
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2013 06:56:29 -0700 (PDT)
In-Reply-To: <51ED370D.2060900@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Chin <hung36987@gmail.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

On 07/22/2013 03:43 PM, Douglas Gilbert wrote:
> On 13-07-22 04:26 AM, Hugh Chin wrote:
>> I'm developing SMP application by Python. I've ran it on Linux, it works
>> fine. But now I have to run it on Windows. Of course, it didn't work.
>>
>> So far I know that Windows seems doesn't have bsg driver. But I'm not
>> sure.
>> I want to know is there any way can run SMP application on Windows?
>>
>> My English is poor, so if you had something misunderstanding. Please
>> let me
>> know.
> 
> My smp_utils package is written for Linux and ported to
> FreeBSD using the latter's CAM interface recently expanded
> to pass-through SMP commands. I'm not aware of any such
> generic SMP pass-through for Windows but I'd be happy
> to be corrected.

Agree, there is no such generic SMP pass-through interface for Windows,
Different Vendor offer their SMP IOCTL interface there own. You can
checkout from your hardware vendor.
> 
> Apart from that, this is probably the wrong list to be
> discussing this subject.
Agree.

Jack
> 
> Doug Gilbert
> 
> 


