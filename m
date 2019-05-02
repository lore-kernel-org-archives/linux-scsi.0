From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Date: Thu, 2 May 2019 08:13:20 +0300
Message-ID: <20190502051320.GF7676@mtr-leonro.mtl.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
 <20190501095722.6902-8-michal.kalderon@marvell.com>
 <20190501.203522.1577716429222042609.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190501.203522.1577716429222042609.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, David Miller <davem@davemloft.net>
Cc: ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 01, 2019 at 08:35:22PM -0400, David Miller wrote:
> From: Michal Kalderon <michal.kalderon@marvell.com>
> Date: Wed, 1 May 2019 12:57:19 +0300
>
> > diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
> > index d93c8a893a89..8bc6775abb79 100644
> > --- a/drivers/infiniband/hw/qedr/main.c
> > +++ b/drivers/infiniband/hw/qedr/main.c
> > @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
> >  MODULE_AUTHOR("QLogic Corporation");
> >  MODULE_LICENSE("Dual BSD/GPL");
> >
> > +static uint iwarp_cmt;
> > +module_param(iwarp_cmt, uint, 0444);
> > +MODULE_PARM_DESC(iwarp_cmt, " iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default: Disabled");
> > +
>
> Sorry no, this is totally beneath us.

It is not acceptable for RDMA too.

Also please don't use comments inside function calls, it complicates
various checkers without real need.
dev->ops->iwarp_set_engine_affin(dev->cdev, true /* reset */);
                                                ^^^^^^^^^^^^^^
Thanks
