From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 08:57:09 -0700
Message-ID: <570E6C55.1060003@sandisk.com>
References: <57067F19.3030404@sandisk.com>
 <1460044289.2311.5.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0092.outbound.protection.outlook.com ([157.56.111.92]:60288
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbcDMP5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2016 11:57:22 -0400
In-Reply-To: <1460044289.2311.5.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>

(+ LSF mailing list)

On 04/07/2016 08:51 AM, James Bottomley wrote:
> On Thu, 2016-04-07 at 08:39 -0700, Bart Van Assche wrote:
>> Some time ago I proposed to discuss how to improve discard support
>> during the LSF/MM (http://thread.gmane.org/gmane.linux.scsi/110048).
>> I would appreciate it if this would be added to the LSF/MM agenda
>> since there has been no progress yet for the patch series I posted in
>> December 2015.
>
> Well, adding a cc to the lsf@ list to interest the attendees might have
> been a good idea.
>
> The basic problem with this topic is that it didn't really garner any
> interest when you proposed it.  It also really just looks like there's
> nothing to discuss: you just propose the unifying patch and people
> discuss and modify that and it either gets accepted or not depending on
> the level of the objections.

Hello James,

There is something that should be discussed further, namely what the 
behavior of the BLKDISCARD and BLKSECDISCARD ioctls should be if the 
start and/or end sectors are not aligned on a discard boundary. Should 
such requests fail with an error code, should the non-aligned head and 
tail be zeroed or should the non-aligned parts be left unmodified?

Thanks,

Bart.
