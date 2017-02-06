From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 29/39] megaraid_sas: Do not set fp_possible if TM capable
 for non-RW syspdIO, change fp_possible to bool
Date: Mon, 6 Feb 2017 16:58:59 +0100
Message-ID: <e2575d81-bbc5-dc12-d0d4-0fc1267820a8@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754099AbdBFP7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:59:02 -0500
In-Reply-To: <1486375212-17329-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 11:00, Shivasharan S wrote:
> FIX - firmware wants non-RW SYS PD IOs to avoid FastPath for
> better tracking and other functionalities if the device
> is task management capable.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
