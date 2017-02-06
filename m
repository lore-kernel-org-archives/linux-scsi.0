From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 24/39] megaraid_sas: Change max_cmd from u32 to u16 in all
 functions
Date: Mon, 6 Feb 2017 16:51:47 +0100
Message-ID: <e65bec1b-9a5b-6442-fa62-80c1fdd45e66@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-25-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdBFPvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:51:50 -0500
In-Reply-To: <1486375212-17329-25-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> Since maximum supported FW commands are all defined as u16, change
> all local variables referring to max_cmd from u32 to u16.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
