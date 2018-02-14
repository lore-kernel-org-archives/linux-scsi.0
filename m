From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [V1] mpt3sas: Do not use 32-bit atomic request descriptor for
 Ventura controllers.
Date: Wed, 14 Feb 2018 18:07:47 +0100
Message-ID: <fcff8324-229c-7c24-432e-c303128be77e@redhat.com>
References: <1518603397-3941-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033141AbeBNRHt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 12:07:49 -0500
In-Reply-To: <1518603397-3941-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com

On 02/14/2018 11:16 AM, Suganath Prabu S wrote:
> Problem Statement: Sending I/O through 32 bit descriptors to
>  Ventura series of controller results in IO timeout on certain conditions.
>
> This error only occurs on systems with high I/O activity on
> Ventura series controllers.
>
> Changes in this patch will prevent driver from using 32 bit descriptor
> and use 64 bit Descriptors
>
> V1 Change set:
> 1) In this patch removed callbacks as suggested by Hannes.
>
> Note:
>  This patch Should be applied on top of
> https://www.spinics.net/lists/linux-scsi/msg117405.html
> "Adding MPI Endpoint device support" patches.
>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
