From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Mon, 13 Oct 2014 11:15:53 +0300
Message-ID: <543B8A39.5040102@dev.mellanox.co.il>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>	<5434D272.8090007@dev.mellanox.co.il> <CAEc=gqbKrqK_PdN8XOfkaNZgscMeODL=i6oFU+SwQrMxT2gixg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEc=gqbKrqK_PdN8XOfkaNZgscMeODL=i6oFU+SwQrMxT2gixg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jayamohan.K" <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/9/2014 8:14 AM, Jayamohan.K wrote:
<SNIP>
>     Hi Minh and Jayamohan,
>
>     So I agree that we would want to take device capabilities into account
>     here, but we need to be able to adjust scsi_cmds_max (can_queue) in case
>     the max wqe supported is lower than scsi_cmds_max * num_posts_per_cmd.
>
>
>
> I feel we should be fine as long as we support the max_cmds of 128
> supported by open-iscsi layer.
>

The cmds_max can be modified by the user, so we should be fine in this
case as well.

> I see the iser layer uses a value of 512 though it only serves as a
> limit check.

So if iser supports less than 512 (due to device capability) the
boundary check should be modified as well.

>
>
>     So generally I agree with this approach, but we need to take care of
>     stuff later when the session is created.
>
>     One more thing, this is not rebased on the latest iser patches please
>     send v1 on top of:
>     http://marc.info/?l=linux-__rdma&m=141216135013146&w=2
>     <http://marc.info/?l=linux-rdma&m=141216135013146&w=2>
>
>
> Yes, I will recreate the patch and send on top of this

Great!

>
>
>
>     P.S.
>     What device did you test with (that supports less than iSER needs)?
>

This question still holds.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
