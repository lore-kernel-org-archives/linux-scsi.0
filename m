From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/4] megaraid_sas: add correct return type check for ldio
 hint logic for raid1
Date: Fri, 10 Mar 2017 17:00:20 +0100
Message-ID: <6ec7f1c4-6dd1-153c-4601-7acfa51516a3@redhat.com>
References: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1489144935-26567-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932708AbdCJQAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 11:00:22 -0500
In-Reply-To: <1489144935-26567-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 10.3.2017 12:22, Shivasharan S wrote:
> Return value check of atomic_dec_if_positive is required as it returns old value minus one.
> Without this fix, driver will send small ios to firmware path and that will be a performance issue.
>
> Not a critical, but good to have r1_ldio_hint as default value in sdev private.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
