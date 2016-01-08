From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2, RESEND] Separate target visibility from reaped state
 information
Date: Fri, 8 Jan 2016 17:15:17 +0100
Message-ID: <568FE095.4060901@sandisk.com>
References: <568CCF4F.2000108@sandisk.com>
 <1452095926.2312.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:33888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755797AbcAHQPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jan 2016 11:15:25 -0500
In-Reply-To: <1452095926.2312.2.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>

On 01/06/2016 04:58 PM, James Bottomley wrote:
> On Wed, 2016-01-06 at 09:24 +0100, Bart Van Assche wrote:
>> Instead of representing the states "visible in sysfs" and
>> "has been removed from the target list" by a single state
>> variable, use two variables to represent this information.
>>
>> This patch avoids that SCSI device removal can trigger a
>> soft lockup.
>
> It does?  When I asked you this the last time, you said the soft lockup
> was fixed by a prior patch:
>
> http://thread.gmane.org/gmane.linux.scsi/107248
>
> If you've actually caught a problem, can we have details because the
> distro people will want to know what gets fixed by this.

Hello James,

I will address your feedback and repost this patch.

Bart.
