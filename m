From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v5 14/14] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Mon, 31 Oct 2016 06:59:35 -0700
Message-ID: <c8c503bf-4fcb-5e1d-487a-53277bc1c300@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
 <fe057bf0-6ede-fc9e-9a53-9d790c9782c2@sandisk.com>
 <540193784.5466628.1477921998345.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540193784.5466628.1477921998345.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 10/31/2016 06:53 AM, Laurence Oberman wrote:
> Ran multiple read/write buffered and directio tests via RDMA/SRP and mlx5 (100Gbit) with max_sectors_kb set to 1024, 2048, 4096 and 8196
> Ran multiple read/write buffered and directio tests via RDMA/SRP and mlx4 (56Gbit)  with max_sectors_kb set to 1024, 2048, 4096 and 8196
> Reset the SRP hosts multiple times with multipath set to no_path_retry queue
> Ran basic NVME read/write testing with no hot plug disconnects on multiple block sizes
>
> All tests passed.
>
> For the series:
> Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello Laurence,

Thanks for having tested this version of this patch series again so quickly!

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
