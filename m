From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 11/13] SCSI/libiscsi: Add check_protection callback for transports
Date: Mon, 17 Mar 2014 23:46:04 +0200
Message-ID: <CAJZOPZL_=UU8PmGRq_6OdHzkiw-eMRvbPQx2td-hSU46tAci_A@mail.gmail.com>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com>
	<1394041431-28399-12-git-send-email-sagig@mellanox.com>
	<CAJZOPZ+DtO7AqMgFJqm7uz2zwxk5Gs__J10qHhwB0RbAxzYTkQ@mail.gmail.com>
	<532729DD.1040506@cs.wisc.edu>
	<53275C4F.1040103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53275C4F.1040103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <MChristie-5c4llco8/ftWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 17, 2014, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 3/17/2014 6:59 PM, Mike Christie wrote:

>> This patch is ok, but happened to the patch for the xmit task path?

> Hey Mike, Thanks for your Ack on this.
> The xmit_task fix was posted as a separate patch since it is not specific
> to this set (relevant also for existing data dma_mapping in xmit_task).
> Care to pick it up? http://marc.info/?l=linux-scsi&m=139404160818424&w=2

Hi Roland, provided that Mike Christie acked the libiscsi patch from
this series, and I acked the iser patches and you had no other
comments on the series -- can you pick this for 3.15? The merge window
is coming soon, if for some reason this will not work for you, I'd
like Nic to push that through his tree along with the iser target DIF
patches, so need your asap reply, please.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
