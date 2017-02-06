From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 25/39] megaraid_sas: update can_queue only if the new
 value is less
Date: Mon, 6 Feb 2017 16:52:23 +0100
Message-ID: <75712eeb-f7b8-107e-428a-2a111a5d3c87@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752380AbdBFPw0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:52:26 -0500
In-Reply-To: <1486375212-17329-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> Minor Optimization: No need to update HBA can_queue value
> if the current max FW commands is equal to earlier value.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
