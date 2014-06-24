From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 12:00:40 -0500
Message-ID: <53A9AEB8.4040104@cs.wisc.edu>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net> <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> <53A9A702.8050503@dev.mellanox.co.il> <20140624163040.GA11499@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140624163040.GA11499-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/24/2014 11:30 AM, Christoph Hellwig wrote:
> On Tue, Jun 24, 2014 at 07:27:46PM +0300, Sagi Grimberg wrote:
>> This condition only matters in the bidi case, which is not relevant for the
>> PI case.
>> I suggested to condition that in libiscsi (posted in the second thread,
>> copy-paste below).
>> Although I do agree that scsi_transfer_length() helper is not really just
>> for PI and not more.
>> I think Mike's way is cleaner.
> 
> But for bidi there are two transfers.  So either scsi_transfer_length()
> needs to take the scsi_data_buffer, or we need to avoid using it.
> 
> For 3.16 I'd prefer something like you're patch below.  This patch which
> has been rushed in last minute and not through the scsi tree has already
> causes enough harm.  If you can come up with a clean version to
> transparently handle the bidi case I'd be happy to pick that up for
> 3.17.
> 
> In the meantime please provide a version of the patch below with a
> proper description and signoff.
> 

It would be nice to just have one function to call and it just do the
right thing for the drivers. I am fine with Sagi's libiscsi patch for
now though:

Acked-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
