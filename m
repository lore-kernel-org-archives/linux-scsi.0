From: Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: sym53c8xx_2 is flooding my syslog ...
Date: Wed, 11 Jan 2006 11:40:38 +1100
Message-ID: <43C45406.3040004@bigpond.net.au>
References: <430FD71C.6050704@bigpond.net.au> <43632635.7080604@bigpond.net.au> <20060110174904.GS3911@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:8916 "EHLO
	omta05ps.mx.bigpond.com") by vger.kernel.org with ESMTP
	id S1030183AbWAKAkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 19:40:41 -0500
In-Reply-To: <20060110174904.GS3911@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Oct 29, 2005 at 05:35:17PM +1000, Peter Williams wrote:
> 
>>Peter Williams wrote:
>>
>>>... with the following message:
>>>
>>>Aug 21 04:53:28 mudlark kernel: ..<6>sd 0:0:6:0: phase change 6-7 
>>>9@01ab97a0 resid=7.
>>>
>>>every 2 seconds.  Since the problem being reported seems to have no 
>>>effect on the operation of the scsi devices is it really necessary to 
>>>report it so often?
>>>
>>
>>This problem is still occurring on 2.6.14.
> 
> 
> And still in 2.6.15?

No.  It seems to have stopped.

Thanks
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
