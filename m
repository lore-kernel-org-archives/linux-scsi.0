From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] stex: Fix for potential invalid response
Date: Mon, 26 Jan 2009 19:16:55 +0000
Message-ID: <1232997415.3248.50.camel@localhost.localdomain>
References: <85ABFDC4641C4847BA6088F2982EFD8F01DC8300@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56191 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbZAZTQ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 14:16:57 -0500
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F01DC8300@nonamew.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin - PTU <ed.lin@promise.com>
Cc: linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>

On Mon, 2009-01-26 at 02:40 -0800, Ed Lin - PTU wrote:
> The interrupt routine is good for normal cases. However, if the firmware
> is abnormal and returns an invalid response, the driver may reuse a
> ccb structure which has already been handled. This may cause problem.
> Fix this by setting the req member to NULL. Next time we know the
> response is invalid and handle accordingly if req is NULL.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>
> ---
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index a3a18ad..6129db4 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32
> doorbell)

The patches generally look fine.  Unfortunately your email tool has
broken the line ends of most of them (like the above) which makes it
almost impossible to apply them.  Could you resend with this fixed up?

Thanks,

James


