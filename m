From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v6 2/2] tcmu: Add global data block pool support
Date: Mon, 01 May 2017 22:26:24 -0700
Message-ID: <1493702784.23202.64.camel@haakon3.risingtidesystems.com>
References: <1493187952-13125-1-git-send-email-lixiubo@cmss.chinamobile.com>
         <1493187952-13125-3-git-send-email-lixiubo@cmss.chinamobile.com>
         <590592D4.8090607@redhat.com>
         <25e7247f-116f-aaa5-e895-b503c0a893f9@cmss.chinamobile.com>
         <59078120.3000200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <59078120.3000200@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Xiubo Li <lixiubo@cmss.chinamobile.com>, agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-05-01 at 13:40 -0500, Mike Christie wrote:
> On 04/30/2017 06:29 AM, Xiubo Li wrote:
> > [...]

<SNIP>

> >> To avoid starvation, I think you want a second list/fifo that holds the
> >> watiers. In tcmu_get_empty_block if the list is not empty, record how
> >> many pages we needed and then add the device to the list and wait in
> >> tcmu_queue_cmd_ring.
> >>
> >> Above if we freed enough pages for the device at head then wake up the
> >> device.
> >>
> >> I think you also need a wake_up call in the completion path in case the
> >> initial call could not free enough pages. It could probably check if the
> >> completion was going to free enough pages for a waiter and then call
> >> wake.
> >>
> > Yes, I meant to introduce this later after this series to not let the
> > patches too
> > complex to review.
> > 
> > If you agree I will do this later, or in V7 series ?
> 
> 
> Yeah, I am ok with adding it after the initial patches go in.

Btw, adding your Acked-by for the initial merge of these.

If that's a problem, please make some noise.  ;)
