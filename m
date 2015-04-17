From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Fri, 17 Apr 2015 15:43:35 -0600
Message-ID: <55317E87.2060404@kernel.dk>
References: <1429301471-5666-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34743 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbbDQVni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 17:43:38 -0400
Received: by pdbqa5 with SMTP id qa5so140220341pdb.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2015 14:43:38 -0700 (PDT)
In-Reply-To: <1429301471-5666-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 04/17/2015 02:11 PM, Christoph Hellwig wrote:
> This patch changes the !blk-mq path to the same defaults as the blk-mq
> I/O path by always enabling block tagging, and always using host wide
> tags.  We've had blk-mq available for a few releases so bugs with
> this mode should have been ironed out, and this ensures we get better
> coverage of over tagging setup over different configs.

Ack! This is great, and makes my life easier...

-- 
Jens Axboe

