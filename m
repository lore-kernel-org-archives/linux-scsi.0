From: Tom Psyborg <pozega.tomislav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/20] drop useless LIST_HEAD
Date: Tue, 25 Dec 2018 23:12:20 +0100
Message-ID: <CAKR_QVLeZBL43W4x1mzcfcakSZyyh9L81vgUMxfnSccKawEfdg@mail.gmail.com>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <CAKR_QVJefW1vxYb7-qiU8=0YdbFghYo15SK2eGjOC-dntRfyYA@mail.gmail.com> <alpine.DEB.2.21.1812232304130.2940@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.21.1812232304130.2940@hadrien>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

there was discussion about this just some days ago. CC 4-5 lists is
more than enough

On 23/12/2018, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org> wrote:
>
>
> On Sun, 23 Dec 2018, Tom Psyborg wrote:
>
>> Why do you CC this to so many lists?
>
> Because the different files are in different subsystems.  The cover letter
> goes to a list for each file, or to a person if there is no list.  The
> patches go to the people and lists associated with the affected files.
>
> julia
>
>>
>> On 23/12/2018, Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org> wrote:
>> > Drop LIST_HEAD where the variable it declares is never used.
>> >
>> > ---
>> >
>> >  drivers/dma/at_hdmac.c                                |    5 -----
>> >  drivers/dma/dw/core.c                                 |    1 -
>> >  drivers/dma/pl330.c                                   |    1 -
>> >  drivers/dma/sa11x0-dma.c                              |    2 --
>> >  drivers/dma/st_fdma.c                                 |    3 ---
>> >  drivers/infiniband/ulp/ipoib/ipoib_ib.c               |    1 -
>> >  drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    5 -----
>> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |    3 ---
>> >  drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |    1 -
>> >  drivers/net/wireless/st/cw1200/queue.c                |    1 -
>> >  drivers/scsi/lpfc/lpfc_nvme.c                         |    2 --
>> >  drivers/scsi/lpfc/lpfc_scsi.c                         |    2 --
>> >  drivers/scsi/lpfc/lpfc_sli.c                          |    1 -
>> >  drivers/scsi/qla2xxx/qla_init.c                       |    1 -
>> >  drivers/xen/xenbus/xenbus_dev_frontend.c              |    2 --
>> >  fs/btrfs/relocation.c                                 |    1 -
>> >  fs/nfs/nfs4client.c                                   |    1 -
>> >  fs/nfsd/nfs4layouts.c                                 |    1 -
>> >  fs/xfs/xfs_buf.c                                      |    1 -
>> >  fs/xfs/xfs_fsops.c                                    |    1 -
>> >  20 files changed, 36 deletions(-)
>> >
>>
>
