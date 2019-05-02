From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Date: Wed, 01 May 2019 20:35:22 -0400 (EDT)
Message-ID: <20190501.203522.1577716429222042609.davem@davemloft.net>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
        <20190501095722.6902-8-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190501095722.6902-8-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com
Cc: ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Wed, 1 May 2019 12:57:19 +0300

> diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
> index d93c8a893a89..8bc6775abb79 100644
> --- a/drivers/infiniband/hw/qedr/main.c
> +++ b/drivers/infiniband/hw/qedr/main.c
> @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
>  MODULE_AUTHOR("QLogic Corporation");
>  MODULE_LICENSE("Dual BSD/GPL");
>  
> +static uint iwarp_cmt;
> +module_param(iwarp_cmt, uint, 0444);
> +MODULE_PARM_DESC(iwarp_cmt, " iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default: Disabled");
> +

Sorry no, this is totally beneath us.
