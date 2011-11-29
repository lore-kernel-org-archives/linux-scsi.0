From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 1/2] cciss: add Smart Array 5i to the kdump blacklist
Date: Tue, 29 Nov 2011 13:17:58 -0600
Message-ID: <20111129191758.GO6635@beardog.cce.hp.com>
References: <4ED39C33.5090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4569 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab1K2TR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2011 14:17:59 -0500
Content-Disposition: inline
In-Reply-To: <4ED39C33.5090004@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>

On Mon, Nov 28, 2011 at 03:35:31PM +0100, Tomas Henzl wrote:
> The '5i' controller freezes when a kdump is attemted.
> This patch admits it and adds the controller
> to the unresetable list.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> ---
>  drivers/block/cciss.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 8f4ef65..b43ed87 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -576,12 +576,14 @@ static u32 unresettable_controller[] = {
>  	0x3215103C, /* Smart Array E200i */
>  	0x3237103C, /* Smart Array E500 */
>  	0x323D103C, /* Smart Array P700m */
> +	0x40800E11, /* Smart Array 5i */
>  	0x409C0E11, /* Smart Array 6400 */
>  	0x409D0E11, /* Smart Array 6400 EM */
>  };
>  
>  /* List of controllers which cannot even be soft reset */
>  static u32 soft_unresettable_controller[] = {
> +	0x40800E11, /* Smart Array 5i */
>  	0x409C0E11, /* Smart Array 6400 */
>  	0x409D0E11, /* Smart Array 6400 EM */
>  };
> -- 
> 1.7.6.4
> 
> 

Ack.

-- steve
