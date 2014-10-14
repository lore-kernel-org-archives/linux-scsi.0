From: Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and
 send_wr
Date: Tue, 14 Oct 2014 05:19:13 +0000
Message-ID: <12daeb47-f7a3-4774-b4c0-e96600b479e1@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


>On Tue, Oct 7, 2014 at 10:58 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>On 10/8/2014 3:41 AM, Jay Kallickal wrote:
>>From: Jayamohan Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

>>      This patch allows the underlying hardware to choose
>>values other than  hard coded max values for cqe and send_wr
>>while preventing them from exceeding max supported values.

>Hi Minh and Jayamohan,

>So I agree that we would want to take device capabilities into account
>here, but we need to be able to adjust scsi_cmds_max (can_queue) in case
>the max wqe supported is lower than scsi_cmds_max * num_posts_per_cmd.


I feel we should be fine as long as we support the max_cmds of 128 supported by open-iscsi layer.

I see the iser layer uses a value of 512 though it only serves as a limit check. 


>So generally I agree with this approach, but we need to take care of
>stuff later when the session is created.

>One more thing, this is not rebased on the latest iser patches please
>send v1 on top of: http://marc.info/?l=linux-rdma&m=141216135013146&w=2

Yes, I will recreate the patch and send on top of this


Resending:
 Looks like my response got dropped by the filters.

Am travelling . Minh is working on the patches and would respond 
-Jay
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
