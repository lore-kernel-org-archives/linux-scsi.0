From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] mpt fusion: Update MPI Headers to version 01.05.19
Date: Tue, 06 Jan 2009 09:20:56 -0600
Message-ID: <1231255256.7090.7.camel@localhost.localdomain>
References: <20090106092618.GC13033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50989 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbZAFPU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 10:20:59 -0500
In-Reply-To: <20090106092618.GC13033@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathyap@lsi.com

On Tue, 2009-01-06 at 14:56 +0530, Kashyap, Desai wrote:
> This Patch is submitted to increment the MPI headers used by LSI MPT fusion
> drivers to the latest version 01.05.19.

You mean 01.05.16?  That's what all the headers say:

> Year is changed in CopyRight.
> ---
> 
> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/lsi/mpi.h b/drivers/message/fusion/lsi/mpi.h
> index 10b6ef7..11c0f46 100644
> --- a/drivers/message/fusion/lsi/mpi.h
> +++ b/drivers/message/fusion/lsi/mpi.h
> @@ -6,7 +6,7 @@
>   *          Title:  MPI Message independent structures and definitions
>   *  Creation Date:  July 27, 2000
>   *
> - *    mpi.h Version:  01.05.13
> + *    mpi.h Version:  01.05.16
                         ^^^^^^^^

James


