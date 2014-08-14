From: Boaz Harrosh <openosd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Thu, 14 Aug 2014 10:17:53 +0300
Message-ID: <53EC62A1.7030607@gmail.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-3-git-send-email-sagig@mellanox.com> <53D4CFAB.3040804@gmail.com> <53E22300.3090907@dev.mellanox.co.il> <53E22CE6.9070202@gmail.com> <53EB639C.3080307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53EB639C.3080307-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 08/13/2014 04:09 PM, Sagi Grimberg wrote:
> On 8/6/2014 4:25 PM, Boaz Harrosh wrote:
> 
> Hey Boaz,
> 
> So in the current flow, I still don't think it is wrong/buggy, the
> transfer byte length related to scsi buffer length 
(In iscsi for sure 
> but I think that for all transports it is the same).
> 
> But,
> Since you have such a strong objection on this I'm also OK with changing
> stuff... We can pass a buffer to scsi_transfer_length (although it has 
> no meaning effectively) and we can keep in/out_len local variables and
> print them along with total transfer.
> 
> Do you want me to send out a patch here (since I have some hardware to 
> test it...) or are you still planning to send out something?
> 

I'll do it. As you said there is no bugs, just ugly code. I will send a
cleanup

Thanks
Boaz

> Cheers,
> Sagi.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
