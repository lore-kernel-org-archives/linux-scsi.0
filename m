From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 02/15] megaraid_sas: set minimum value of resetwaittime
 to be 1 secs
Date: Mon, 10 Jul 2017 15:47:27 +0200
Message-ID: <8d276e5b-117f-258c-ecf7-0c22f02ba82f@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932122AbdGJNrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 09:47:31 -0400
In-Reply-To: <1499256029-16319-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 5.7.2017 14:00, Shivasharan S wrote:
> Setting resetwaittime to 0 during a FW fault will result in driver
> not calling the OCR.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash
