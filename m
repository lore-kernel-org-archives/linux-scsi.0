From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 25 Jun 2014 04:35:36 -0700
Message-ID: <20140625113536.GA30312@infradead.org>
References: <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
 <53A9A702.8050503@dev.mellanox.co.il>
 <20140624163040.GA11499@infradead.org>
 <53A9AEB8.4040104@cs.wisc.edu>
 <53A9B0A0.6000103@cs.wisc.edu>
 <53AA42E6.3090101@cs.wisc.edu>
 <53AA8CF7.8050102@dev.mellanox.co.il>
 <53AAA547.40300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53AAA547.40300-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 25, 2014 at 01:32:39PM +0300, Sagi Grimberg wrote:
> So I tested a bidirectional command using:
> $ sg_raw --infile=/root/filex --send=1024 --request=1024
> --outfile=/root/filex "/dev/bsg/7:0:0:0" 53 00 00 00 00 00 00 00 02 00
> 
> And I see:
> kernel: session1: iscsi_prep_scsi_cmd_pdu iscsi prep [bidirectional cid 0 sc
> ffff880468ca1e00 cdb 0x53 itt 0x16 len 1024 bidi_len 1024 cmdsn 223 win 64]
> 
> This confirms what I wrote above, so AFAICT no additional fix is required
> for libiscsi wrt bidi commands support.

Good to know.  I'd really prefer just going with the fix from Martin
that I have already queued up for 3.16, and then we can have the fully
fledged out "new" scsi_transfer_length() for 3.17.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
