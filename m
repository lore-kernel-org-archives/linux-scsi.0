From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Fri, 3 Mar 2006 15:24:14 -0500
Message-ID: <F9810B12-E068-43EB-9FF2-CF9E7D721CE5@egenera.com>
References: <44071BA4.3030808@vlnb.net> <8932FBA5-241C-470E-A928-F34868EC0A8D@egenera.com> <44088F29.5030009@s5r6.in-berlin.de>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:65502 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S932211AbWCCUYS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 15:24:18 -0500
In-Reply-To: <44088F29.5030009@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org


On Mar 3, 2006, at 1:47 PM, Stefan Richter wrote:

> Steve Byan wrote:
>> On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
>>> Apparently, hardware SCSI targets don't suffer from queuing   
>>> overflow
> [...]
>> No, they just have big queues.
>
> Depending on the the transport protocol, the problem of queue depth  
> at the target may not even exist in the first place. This is the  
> case with SBP-2 where the queue of command blocks resides at the  
> initiator.

Yes, and that's a clever optimization in SBP-2 to support resource- 
poor targets. Thanks for reminding us of it.

Too bad SATA drives didn't take advantage of the SATA first-party DMA  
to implement SBP-2. The definition of the tag field for native  
command queuing adopted by T13 essentially makes it infeasible to  
revisit this decision.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


