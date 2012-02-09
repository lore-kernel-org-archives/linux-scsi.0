From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Wed, 8 Feb 2012 22:40:28 -0500
Message-ID: <20120209034028.GB17456@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896Ab2BIDkd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2012 22:40:33 -0500
Content-Disposition: inline
In-Reply-To: <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

On Mon, Jan 30 2012 at  7:31pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
> index c1eb41c..e5f4194 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -206,3 +206,16 @@ Description:
>  		when a discarded area is read the discard_zeroes_data
>  		parameter will be set to one. Otherwise it will be 0 and
>  		the result of reading a discarded area is undefined.
> +
> +What:		/sys/block/<disk>/queue/max_write_same_bytes
> +Date:		January 2012
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Some devices support a write same operation in which a
> +		single data block can be written to a range of several
> +		contiguous blocks on storage. This can be used to wipe
> +		areas on disk or to initialize drives in a RAID
> +		configuration. max_write_same_bytes indicates how many
> +		bytes can be written in a single write same command. If
> +		max_write_same_bytes is 0, write same is not supported
> +		by the device.

How about write_same_max_bytes to follow the pattern established with
/sys/block/<disk>/queue/discard_max_bytes?
