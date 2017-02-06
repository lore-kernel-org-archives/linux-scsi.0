From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 32/39] megaraid_sas: Bail out the driver load if
 ld_list_query fails
Date: Mon, 6 Feb 2017 17:01:31 +0100
Message-ID: <b41f1947-ff3e-23b8-3b38-4ca0781d897f@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdBFQBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 11:01:34 -0500
In-Reply-To: <1486375212-17329-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 11:00, Shivasharan S wrote:
> Error handling: Bail out the driver load if
> key FW cmds (LD_LIST) are not return successful.
> Clean up error handling in megasas_init_fw.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
