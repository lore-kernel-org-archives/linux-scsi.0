From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 16/39] megaraid_sas: reduce size of fusion_context and use
 vmalloc if kmalloc fails
Date: Mon, 6 Feb 2017 16:40:15 +0100
Message-ID: <6678cd15-798e-cb06-3b25-d79a7ca30530@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752165AbdBFPkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:40:18 -0500
In-Reply-To: <1486375212-17329-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> Currently fusion context has fixed array load_balance_info. Use dynamic allocation.
> In few places, driver do not want physically contigious memory.
> Attempt to use vmalloc if physical contiguous memory is not available.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
