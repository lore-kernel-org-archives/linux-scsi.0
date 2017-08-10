From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: SCSI Oops: Unable to handle kernel NULL ptr dereference
Date: Thu, 10 Aug 2017 18:01:39 -0400
Message-ID: <1502402499.4120.133.camel@localhost.localdomain>
References: <20170810170537.Horde.8CxBesYMH_QVGbAB7dui6vz@www.vfemail.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdHJWBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 18:01:40 -0400
In-Reply-To: <20170810170537.Horde.8CxBesYMH_QVGbAB7dui6vz@www.vfemail.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: manday@openmail.cc
Cc: linux-scsi@vger.kernel.org

[cc's snipped to linux-scsi ]

On Thu, 2017-08-10 at 17:05 +0000, manday@openmail.cc wrote:
> Hello,
> 
> I'd like to report this rare panic I experienced today. I've been on  
> 4.12.3 since it was released and got this panic totally unexpected,  
> probably when terminating my WL compositor. I attach to this message a  
> capture of the screen. The problem occurred never before and never  
> after since, suggesting I will not be able to reproduce it easily.  
> Perhaps it means something to someone.
> 
> Linux air 4.12.3 #4 SMP Fri Jul 28 12:07:06 CEST 2017 x86_64 Intel(R)  
> Core(TM)i5-6267U CPU @ 2.90GHz GenuineIntel GNU/Linux
> 
> I don't know what additional information might be useful so if there  
> is anything else I should provide please tell me.
> 
> Best regards,
> Cedric

Your stack trace indicates some kind of corruption in a kmem cache
used by the SCSI code, uncovered when the block queue was being freed.
Can you describe what SCSI hardware is connected to your machine?
A snippet of your boot messages showing the hardware probe would help.

-Ewan
