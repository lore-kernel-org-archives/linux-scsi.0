From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v9 09/10] block, scsi: Make SCSI quiesce and resume work reliably
Date: Tue, 17 Oct 2017 00:17:32 -0400
Message-ID: <yq11sm2xvab.fsf@oracle.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
        <20171016232905.5047-10-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41684 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758573AbdJQERw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 00:17:52 -0400
In-Reply-To: <20171016232905.5047-10-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 16 Oct 2017 16:29:04 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> The contexts from which a SCSI device can be quiesced or resumed are:
> * Writing into /sys/class/scsi_device/*/device/state.
> * SCSI parallel (SPI) domain validation.
> * The SCSI device power management methods. See also scsi_bus_pm_ops.

The SCSI bits look fine to me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
