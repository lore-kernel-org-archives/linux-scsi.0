From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: legacy megaraid status
Date: Thu, 22 Sep 2005 09:55:00 -0700
Message-ID: <C2A6572782C9593467A750C4@[10.169.6.233]>
References: <433175AE.5070905@darthvader.us>
 <30E6DB5A16C820CE29D97507@[10.169.6.233]> <4332705E.6030905@darthvader.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segw.microprecisionautomation.com ([69.17.55.168]:47295 "EHLO
	segw.microprecisionautomation.com") by vger.kernel.org with ESMTP
	id S1030444AbVIVQ5Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 12:57:16 -0400
Received: from home.sewingwitch.com (c-67-160-222-127.hsd1.ca.comcast.net [67.160.222.127])
	(authenticated bits=0)
	by segw.microprecisionautomation.com (8.13.1/8.13.1) with ESMTP id j8MGv7uT015799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2005 09:57:15 -0700
Received: from [10.169.6.233] (segw.microprecisionautomation.com [69.17.55.168])
	(authenticated bits=0)
	by home.sewingwitch.com (8.13.1/8.13.1) with ESMTP id j8MGv4j4025391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2005 09:57:05 -0700
In-Reply-To: <4332705E.6030905@darthvader.us>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--On Thursday, September 22, 2005 9:50 AM +0100 Yiannis Mavroukakis 
<jander@darthvader.us> wrote:

> 02:01.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 05)
> (prog-if 01)
>         Subsystem: Hewlett-Packard Company HP NetRAID-1Si
>         Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ
> 17
>         Memory at fe000000 (32-bit, prefetchable) [size=4M]
>         Expansion ROM at <unassigned> [disabled] [size=32K]
>         Capabilities: [80] Power Management version 2

Any idea what the PCI ID quad is? (See the pci.ids file for examples.)

One possibility is that it's "close enough" to one of the cards listed in 
the PCI ID table in megaraid_mbox.c and you can just add the ID for this 
one. I'll wait for one of the LSI people to weigh in on whether that would 
work.


