From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 11/13] SCSI/libiscsi: Add check_protection callback
 for transports
Date: Mon, 17 Mar 2014 22:34:23 +0200
Message-ID: <53275C4F.1040103@dev.mellanox.co.il>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com> <1394041431-28399-12-git-send-email-sagig@mellanox.com> <CAJZOPZ+DtO7AqMgFJqm7uz2zwxk5Gs__J10qHhwB0RbAxzYTkQ@mail.gmail.com> <532729DD.1040506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <532729DD.1040506-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <MChristie-5c4llco8/ftWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 3/17/2014 6:59 PM, Mike Christie wrote:

<SNIP>
> This patch is ok, but happened to the patch for the xmit task path?
>

Hey Mike, Thanks for your Ack on this.

The xmit_task fix was posted as a separate patch since it is
not specific to this set (relevant also for existing data dma_mapping in 
xmit_task).

Care to pick it up? http://marc.info/?l=linux-scsi&m=139404160818424&w=2

Thanks,

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
