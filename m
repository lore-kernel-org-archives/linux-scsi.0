From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Sat, 07 Aug 2010 04:26:34 -0400
Message-ID: <4C5D18BA.9020203@garzik.org>
References: <20100806161622.GA8696@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45788 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0HGI0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2010 04:26:37 -0400
Received: by yxg6 with SMTP id 6so3076971yxg.19
        for <linux-scsi@vger.kernel.org>; Sat, 07 Aug 2010 01:26:37 -0700 (PDT)
In-Reply-To: <20100806161622.GA8696@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sgruszka@redhat.com, satyasrinivasp@hcl.in

On 08/06/2010 12:16 PM, David Milburn wrote:
> mvs_lu_reset should not call mvs_release_task phy number of times,
> each phy is handled in mvs_release_task.
>
> Signed-off-by: David Milburn<dmilburn@redhat.com>
> Cc: Stanislaw Gruszka<sgruszka@redhat.com>
> Cc: Srinivas<satyasrinivasp@hcl.in>
> Cc: Andy Yan<ayan@marvell.com>
> ---
>   drivers/scsi/mvsas/mv_sas.c |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>


