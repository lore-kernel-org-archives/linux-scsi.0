From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 06/16] trivial: use ARRAY_SIZE
Date: Tue, 20 Jul 2010 17:10:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1007201709500.4741@pobox.suse.cz>
References: <1277726105-24600-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277726105-24600-1-git-send-email-segooon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>, Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Krishna Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/scsi/bfa/bfa_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
> index 3a7b3f8..d845506 100644
> --- a/drivers/scsi/bfa/bfa_core.c
> +++ b/drivers/scsi/bfa/bfa_core.c
> @@ -335,7 +335,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
>  		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
>  	};
>  
> -	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
> +	*npciids = ARRAY_SIZE(__pciids);
>  	*pciids = __pciids;
>  }

Doesn't seem to be in linux-next as of today. I have applied the patch to 
trivial queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
