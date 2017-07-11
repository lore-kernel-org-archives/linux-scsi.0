From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Tue, 11 Jul 2017 15:57:00 +0200
Message-ID: <0b276431-ffe8-38fe-db3c-1234e8292c68@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755886AbdGKN5E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 09:57:04 -0400
In-Reply-To: <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 5.7.2017 14:00, Shivasharan S wrote:
> Currently driver sets default queue_depth for VDs at 256 and JBODs based on interface type,
> ie., for SAS JBOD QD will be 64, for SATA JBOD QD will be 32.
> During performance runs with scsi-mq enabled, we are seeing better results by
> setting QD same as HBA queue_depth.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash
