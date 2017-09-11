From: Meelis Roos <mroos@linux.ee>
Subject: Re: [man-pages PATCH] cciss.4, hpsa.4: mention cciss removal in
 Linux 4.13
Date: Mon, 11 Sep 2017 09:58:25 +0300 (EEST)
Message-ID: <alpine.LRH.2.21.1709110958100.23935@math.ut.ee>
References: <20170911025746.GA23341@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:55709 "EHLO smtp1.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdIKG6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Sep 2017 02:58:30 -0400
In-Reply-To: <20170911025746.GA23341@asgard.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eugene Syromyatnikov <evgsyr@gmail.com>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org

On Mon, 11 Sep 2017, Eugene Syromyatnikov wrote:

> During the Linux 4.13 development cycle, cciss driver has been removed
> in flavor to hpsa driver that has been amended with some legacy board
> support.

It's gone in 4.14 - 4.13 works the old way.

> 
> * man4/cciss.4 (.SH DESCRIPTION): Mention driver removal.
> * man4/hpsa.4 (.SH DESCRIPTION): Mention list of boards that recognised
> since Linux 4.13.
> 
> Signed-off-by: Eugene Syromyatnikov <evgsyr@gmail.com>
> ---
>  man4/cciss.4 |  7 +++++++
>  man4/hpsa.4  | 26 ++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/man4/cciss.4 b/man4/cciss.4
> index e6ba93d..ff4c248 100644
> --- a/man4/cciss.4
> +++ b/man4/cciss.4
> @@ -15,6 +15,13 @@ cciss \- HP Smart Array block driver
>  modprobe cciss [ cciss_allow_hpsa=1 ]
>  .fi
>  .SH DESCRIPTION
> +.\" commit 253d2464df446456c0bba5ed4137a7be0b278aa8
> +.BR Note :
> +This obsolete driver was removed from the kernel in version 4.13,
> +as it is superseded by
> +.BR hpsa (4)
> +driver in newer kernels.
> +.PP
>  .B cciss
>  is a block driver for older HP Smart Array RAID controllers.
>  .SS Options
> diff --git a/man4/hpsa.4 b/man4/hpsa.4
> index 63000bf..9b7fd82 100644
> --- a/man4/hpsa.4
> +++ b/man4/hpsa.4
> @@ -52,6 +52,32 @@ driver supports the following Smart Array boards:
>      Smart Array P711m
>      StorageWorks P1210m
>  .fi
> +.PP
> +.\" commit 135ae6edeb51979d0998daf1357f149a7d6ebb08
> +Since Linux 4.13, the following Smart Array boards are also supported:
> +.PP
> +.nf
> +    Smart Array 5300
> +    Smart Array 5312
> +    Smart Array 532
> +    Smart Array 5i
> +    Smart Array 6400
> +    Smart Array 6400 EM
> +    Smart Array 641
> +    Smart Array 642
> +    Smart Array 6i
> +    Smart Array E200
> +    Smart Array E200i
> +    Smart Array E200i
> +    Smart Array E200i
> +    Smart Array E200i
> +    Smart Array E500
> +    Smart Array P400
> +    Smart Array P400i
> +    Smart Array P600
> +    Smart Array P700m
> +    Smart Array P800
> +.fi
>  .SS Configuration details
>  To configure HP Smart Array controllers,
>  use the HP Array Configuration Utility (either
> 

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
