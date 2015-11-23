From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 23 Nov 2015 08:48:31 -0600
Message-ID: <000701d125fe$056c2770$10447650$@opengridcomputing.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-4-git-send-email-hch@lst.de> <564851BB.1020004@dev.mellanox.co.il> <564A067B.8030504@opengridcomputing.com> <003001d1209c$ecb70760$c6251620$@opengridcomputing.com> <564A2270.1040004@dev.mellanox.co.il> <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com> <5652EA67.1000707@dev.mellanox.co.il> <5652EC00.8010705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5652EC00.8010705-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> Sent: Monday, November 23, 2015 4:36 AM
> To: Steve Wise; 'Christoph Hellwig'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; axboe-b10kYP2dOMg@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
> 
> 
> > So Maybe we should have:
> > void ib_drain_qp(struct ib_qp *qp)
> 
> Christoph suggested that this flushing would be taken care
> of by rdma_disconnect which sounds even better I think..
> --

Agreed. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
