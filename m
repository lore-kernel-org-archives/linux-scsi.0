From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/4] scsi: provide UAPI version of scsi/sg.h and
 scsi/scsi_ioctl.h
Date: Fri, 25 Sep 2015 10:44:56 +0200
Message-ID: <56050988.5000504@redhat.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
 <1442497647-17778-1-git-send-email-pbonzini@redhat.com>
 <55FADCFF.5000104@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38254 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbbIYIpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 04:45:11 -0400
In-Reply-To: <55FADCFF.5000104@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org



On 17/09/2015 17:32, Bart Van Assche wrote:
> 
>> +
>> +#ifndef __KERNEL__
>> +/* Keep in sync with SG_DEFAULT_TIMEOUT of scsi/sg.h  */
>>   #define SG_DEFAULT_TIMEOUT    (60*HZ)         /* HZ == 'jiffies in 1
>> second' */
>>   #endif
> 
> Is it useful and/or necessary to export this constant ? To me this looks
> like an implementation aspect rather than an aspect of the scsi-sg API.

That's fine, I can remove it.

Paolo
