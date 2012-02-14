From: Mike Miller <mike.miller@hp.com>
Subject: Re: [PATCH] hpsa: add some older controllers to the kdump blacklist
Date: Tue, 14 Feb 2012 11:11:01 -0600
Message-ID: <4F3A95A5.8040402@hp.com>
References: <4F3A94EF.50300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:6115 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab2BNRLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 12:11:04 -0500
In-Reply-To: <4F3A94EF.50300@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

On 02/14/2012 11:07 AM, Tomas Henzl wrote:
> Some other older controllers also do have problems to perform a kdump.
> Adding controllers to this list means that the driver will signal
> this non-ability via a resettable flag correctly.
> The unsupported list was created after a consultation with HP.
>
> Signed-off-by: Tomas Henzl<thenzl@redhat.com>

Acked-by: Mike Miller <mike.miller@hp.com>

>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index b96962c..faac5a9 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -296,11 +296,23 @@ static u32 unresettable_controller[] = {
>   	0x40800E11, /* Smart Array 5i */
>   	0x409C0E11, /* Smart Array 6400 */
>   	0x409D0E11, /* Smart Array 6400 EM */
> +	0x40700E11, /* Smart Array 5300 */
> +	0x40820E11, /* Smart Array 532 */
> +	0x40830E11, /* Smart Array 5312 */
> +	0x409A0E11, /* Smart Array 641 */
> +	0x409B0E11, /* Smart Array 642 */
> +	0x40910E11, /* Smart Array 6i */
>   };
>
>   /* List of controllers which cannot even be soft reset */
>   static u32 soft_unresettable_controller[] = {
>   	0x40800E11, /* Smart Array 5i */
> +	0x40700E11, /* Smart Array 5300 */
> +	0x40820E11, /* Smart Array 532 */
> +	0x40830E11, /* Smart Array 5312 */
> +	0x409A0E11, /* Smart Array 641 */
> +	0x409B0E11, /* Smart Array 642 */
> +	0x40910E11, /* Smart Array 6i */
>   	/* Exclude 640x boards.  These are two pci devices in one slot
>   	 * which share a battery backed cache module.  One controls the
>   	 * cache, the other accesses the cache through the one that controls
>
>

