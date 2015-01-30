From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Fri, 30 Jan 2015 10:46:17 +0100
Message-ID: <54CB52E9.6000302@redhat.com>
References: <1422486056-11591-1-git-send-email-hch@lst.de> <54CABE29.5080909@redhat.com> <20150130010849.GA4794@ad.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62946 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbbA3JqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2015 04:46:22 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so25824486wgg.7
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 01:46:21 -0800 (PST)
In-Reply-To: <20150130010849.GA4794@ad.nay.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>



On 30/01/2015 02:08, Fam Zheng wrote:
> On Fri, 01/30 00:11, Paolo Bonzini wrote:
>>
>>
>> On 29/01/2015 00:00, Christoph Hellwig wrote:
>>> Lock the device embedded in the scsi_device to protect against
>>> concurrent calls to ->remove.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> I wonder if this makes this problem: https://lkml.org/lkml/2015/1/5/9 go
>> away.
> 
> A quick test says yes.

Great, we might want to revert that patch in 3.21.

Paolo
