From: NucleoDyne Systems <nucleon@nucleodyne.com>
Subject: Re: Raw IO with High mem support.
Date: Wed, 12 Nov 2003 07:26:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB2510D.1010108@nucleodyne.com>
References: <B38A3B4F283DBA419282705B57A2425B154AC1@aime2k02.adaptec.com>
Reply-To: nucleon@nucleodyne.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([204.127.202.56]:1932 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S263639AbTKLPRQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 10:17:16 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Nayak, Samdeep" <Samdeep_Nayak@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Hi,
   What kind of devices you have on the system?

Kallol

Nayak, Samdeep wrote:

>Hi,
>
>I am running into a strange performance issue after I upgraded my system
>ram to 2Gig. Earlier my system had 896MB and I was getting decent
>performance with character raw IO. However after rebuilding the kernel
>to support 4Gig Memory with 3Gig virtual memory on 2.4.X kernel, the
>performance seems to drop drastically. Physically removing the RAM got
>me back to the original performance.  I am still trying to analyze this
>and any pointers to High Memory support with raw device would be greatly
>appreciated.
>
>Thanks in advance,
>-Samdeep
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>


-- 
www.nucleodyne.com
nucleon@nucleodyne.com
Phone: 408-718-8164



