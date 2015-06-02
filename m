From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/10] qla2xxx: Fix various warnings reported by static
 source code analysis tools
Date: Tue, 2 Jun 2015 15:44:29 -0700
Message-ID: <556E31CD.5020407@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
 <F5D084D6342F9B479C34599BB0A03E4D012858B38C@AVMB1.qlogic.org>
 <54EAE9A0.3090205@sandisk.com> <D1935AAF.8FF12%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0067.outbound.protection.outlook.com ([157.56.110.67]:62789
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570AbbFBWog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jun 2015 18:44:36 -0400
In-Reply-To: <D1935AAF.8FF12%himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/02/2015 01:09 PM, Himanshu Madhani wrote:
> On 2/23/15, 12:49 AM, "Bart Van Assche" <bart.vanassche@sandisk.com> wrote:
>> On 02/02/15 05:52, Saurav Kashyap wrote:
>>> Thanks for the patches. We will run regression with these changes and
>>> ack
>>> if everything goes through fine.
>>
>> Hello Saurav,
>>
>> That sounds great. Are there perhaps already any results available from
>> the regression tests ?
>
> Hello Bart,
>
> Replying to correct email thread. We have concluded our regression cycle.
> The series looks good.
>
> Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>

Hello Himanshu,

Thank you for the feedback. Since other qla2xxx driver patches have been 
accepted upstream after my patch series had been posted I think the 
patches should be reposted. Would you prefer to do that or do you 
perhaps prefer that I repost that series ?

Bart.

