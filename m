From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: ->queue_rq can't sleep
Date: Fri, 09 Jan 2015 08:48:47 -0700
Message-ID: <54AFF85F.8060409@kernel.dk>
References: <1420640453-3493-1-git-send-email-hch@lst.de> <20150109115117.GA26918@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37853 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbbAIPsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 10:48:50 -0500
Received: by mail-pa0-f54.google.com with SMTP id fb1so19143718pad.13
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2015 07:48:50 -0800 (PST)
In-Reply-To: <20150109115117.GA26918@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>

On 01/09/2015 04:51 AM, Christoph Hellwig wrote:
> Any chance to get a review / ack for this one?

You can my reviewed-by, looks fine to me.

-- 
Jens Axboe

