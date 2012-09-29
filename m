From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH][SCSI] mpt3sas: Paer 1 of MPI API headers
Date: Sat, 29 Sep 2012 22:52:50 +0200
Message-ID: <878vbsy2jg.fsf@nemi.mork.no>
References: <20120929140743.GA20622@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52437 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab2I2UyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 16:54:25 -0400
In-Reply-To: <20120929140743.GA20622@localhost.localdomain> (sreekanth reddy's
	message of "Sat, 29 Sep 2012 19:37:43 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com

<sreekanth.reddy@lsi.com> writes:

> This patch contains MPI API headers
> This patch is part 1 of MPI API headers.
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> ---
>
>
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/m=
pi/mpi2.h
> new file mode 100644
> index 0000000..03317ff
> --- /dev/null
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
> @@ -0,0 +1,1164 @@

Why can't this and the other headers be shared between the mpt2sas and
mpt3sas drivers?  Looks like you are duplicating a lot of code already
present in drivers/scsi/mpt2sas.  Why?  That's a recipe for maintenance
hell...

And it makes this submission impossible to review.


Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
