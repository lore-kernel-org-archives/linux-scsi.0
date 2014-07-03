From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 01/14] block: Get rid of bdev_integrity_enabled()
Date: Thu, 03 Jul 2014 12:18:56 +0300
Message-ID: <53B52000.9060007@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com> <1401334128-15499-2-git-send-email-martin.petersen@oracle.com> <20140611163148.GA28815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56771 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbaGCJS7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 05:18:59 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so12107967wgg.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 02:18:58 -0700 (PDT)
In-Reply-To: <20140611163148.GA28815@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 6/11/2014 7:31 PM, Christoph Hellwig wrote:
> On Wed, May 28, 2014 at 11:28:35PM -0400, Martin K. Petersen wrote:
>> bdev_integrity_enabled() is only used by bio_integrity_enabled().
>> Combine these two functions.
>>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Looks good,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

