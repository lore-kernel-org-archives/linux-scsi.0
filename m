From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/5] mpt fusion: Update MPI Headers to version 01.05.19
Date: Wed, 7 Jan 2009 11:30:27 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C13FF96712B@inbmail01.lsi.com>
References: <20090106092618.GC13033@lsi.com>
 <1231255256.7090.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:33597 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbZAGGAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2009 01:00:38 -0500
In-Reply-To: <1231255256.7090.7.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

It 01.05.19 is package version whereas 01.05.16 is mpi.h file version.
Version info is available in lsi/mpi_history.txt


Thanks
Kashyap Desai

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Tuesday, January 06, 2009 8:51 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 1/5] mpt fusion: Update MPI Headers to version 01.05.19

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


