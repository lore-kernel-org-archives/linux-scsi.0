From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 04/14] block: Remove bip_buf
Date: Thu, 03 Jul 2014 12:21:35 +0300
Message-ID: <53B5209F.3090904@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com> <1401334128-15499-5-git-send-email-martin.petersen@oracle.com> <20140611163548.GD28815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41582 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbaGCJVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 05:21:39 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so12354098wgg.5
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 02:21:37 -0700 (PDT)
In-Reply-To: <20140611163548.GD28815@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 6/11/2014 7:35 PM, Christoph Hellwig wrote:
> On Wed, May 28, 2014 at 11:28:38PM -0400, Martin K. Petersen wrote:
>> bip_buf is not really needed so we can remove it.
>>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Looks good,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

