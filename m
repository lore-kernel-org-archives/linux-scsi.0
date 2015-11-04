From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] Restart list search after unlock in
 scsi_remove_target
Date: Wed, 4 Nov 2015 15:20:14 -0800
Message-ID: <563A92AE.5000605@sandisk.com>
References: <5633E9F2.5080209@sandisk.com> <5633EA98.8050604@sandisk.com>
 <563A883C.9060501@sandisk.com>
 <1446677072.2216.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:26112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030352AbbKDXUR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2015 18:20:17 -0500
In-Reply-To: <1446677072.2216.30.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/04/2015 02:44 PM, James Bottomley wrote:
> On Wed, 2015-11-04 at 14:35 -0800, Bart Van Assche wrote:
>> (replying to my own e-mail)
>>
>> Hello Christoph,
>>
>> Is it OK for you if I mention you as author of this e-mail ?
>
> Could you just both co-operate, especially since there's not much
> difference between the patches.

Hello James and Christoph,

Patch [2/2] is identical to the patch Christoph had posted except that 
it has been rebased on top of patch [1/2] of this series. I will be 
happy to step back if Christoph or someone else wants to take the lead 
here. The only reason I started looking into this is that there was no 
further progress on the original e-mail thread about this subject 
(http://thread.gmane.org/gmane.linux.kernel/2052359).

Bart.
