From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Suspending SCSI devices and buses
Date: Thu, 19 Aug 2004 17:20:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41251989.3020306@optonline.net>
References: <Pine.LNX.4.44L0.0408191647170.2106-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.allegientsystems.com ([208.251.178.236]:36102 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S267407AbUHSVUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 17:20:11 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408191647170.2106-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:

> Thanks.  Looking at your patch, I have a question.  It doesn't look like
> the resume path is careful to check for Unit Attention with Power On or
> Medium May Have Changed sense.  What happens if somebody changes the
> medium while the drive is suspended?  Or am I missing something?

I just do the same checks that we do on boot. I suppose if somebody does 
this with a mounted filesystem on removeable media the results might be 
rather comical...

Does "Medium May Have Changed" show up reliably if somebody changes the 
medium in a cartridge drive, Zip drive, etc while it is powered down? 
Doesn't the kernel already notice that sense if it happens during normal 
operation?


Nathan

> 
> Alan Stern
> 
> 

