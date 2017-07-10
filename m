From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 03/15] megaraid_sas: Use synchronize_irq in target
 reset case
Date: Mon, 10 Jul 2017 15:50:29 +0200
Message-ID: <aea04581-8040-8512-4110-a512274cfc55@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932079AbdGJNud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 09:50:33 -0400
In-Reply-To: <1499256029-16319-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 5.7.2017 14:00, Shivasharan S wrote:
> Similar to task abort case, use synchronize_irq API in target reset case.
> Also, remove redundant call to megasas_complete_cmd_dpc_fusion
> after calling megasas_sync_irqs in task abort case.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash
