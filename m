From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA status report updated
Date: Fri, 12 Aug 2005 17:33:17 -0400
Message-ID: <42FD159D.7080107@pobox.com>
References: <42FC2EF8.7030404@pobox.com> <42FCF5D3.1080409@danbbs.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:16301 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751285AbVHLVdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 17:33:20 -0400
In-Reply-To: <42FCF5D3.1080409@danbbs.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: monz@danbbs.dk
Cc: Linux IDE Mailing List <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mogens Valentin wrote:
> Jeff Garzik wrote:
> 
>>
>> Things in SATA-land have been moving along recently, so I updated the 
>> software status report:
>>
>>     http://linux.yyz.us/sata/software-status.html
> 
> 
>  >> Queueing support, NCQ:
>  >> #3 will be supported by libata, for all hardware and devices that
>  >> support NCQ.
> 
> I guess this means libata support for HW-based NCQ.
> It also could mean software/driver implemented NCQ, which could work on 
> chipsets not supporting HW-NCQ in unison with a disk having NCQ?

NCQ by definition -requires- support in the controller chip.


>> Although I have not updated it in several weeks, folks may wish to 
>> refer to the hardware status report as well:
>>
>>     http://linux.yyz.us/sata/sata-status.html
> 
> 
> How well does libata work with the newest ULi chipsets?
> If not well, is there a possible timeframe?

No idea.  I don't see many bug reports, so I suppose its OK.

	Jeff


