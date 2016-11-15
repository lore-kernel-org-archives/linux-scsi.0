From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] nvme: untangle 0 and BLK_MQ_RQ_QUEUE_OK
Date: Tue, 15 Nov 2016 12:51:01 -0700
Message-ID: <96ea1cf1-3d84-5e08-e55f-5d903070fed2@kernel.dk>
References: <ec8930a71efdc30f9d5e5c69954f5b10cfab9927.1479236597.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35571 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbcKOTvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 14:51:05 -0500
Received: by mail-pg0-f53.google.com with SMTP id p66so69928907pga.2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 11:51:04 -0800 (PST)
In-Reply-To: <ec8930a71efdc30f9d5e5c69954f5b10cfab9927.1479236597.git.osandov@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-block@vger.kernel.org
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, kernel-team@fb.com

On 11/15/2016 12:11 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> Let's not depend on any of the BLK_MQ_RQ_QUEUE_* constants having
> specific values. No functional change.

Thanks Omar, applied both for 4.10.

-- 
Jens Axboe

