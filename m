From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/18] scsi_dh_emc: switch to scsi_execute_req_flags()
Date: Wed, 25 Jan 2017 22:19:33 -0500
Message-ID: <yq1wpdi8q4a.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17102 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdAZDTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 22:19:52 -0500
In-Reply-To: <1485365126-23210-10-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:17 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> From: Hannes Reinecke <hare@suse.de> Switch to
Christoph> scsi_execute_req_flags() and scsi_get_vpd_page() instead of
Christoph> open-coding it.  Using scsi_execute_req_flags() will set
Christoph> REQ_QUIET and REQ_PREEMPT, but this is okay as we're
Christoph> evaluating the errors anyway and should be able to send the
Christoph> command even if the device is quiesced.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
