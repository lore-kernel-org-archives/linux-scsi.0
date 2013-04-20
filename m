From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH -next] [SCSI] scsi_transport_iscsi: fix error return code
 in iscsi_transport_init()
Date: Sat, 20 Apr 2013 01:06:41 -0700
Message-ID: <51724C91.9050203@cs.wisc.edu>
References: <CAPgLHd_o7fK8G8_T7Q=S0=XWkgR=g7qWE5uGhHv=bz4BxhB0zA@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBIMZZGFQKGQERQQXWFI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <CAPgLHd_o7fK8G8_T7Q=S0=XWkgR=g7qWE5uGhHv=bz4BxhB0zA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 04/18/2013 06:23 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> 
> Fix to return -ENOMEM in the create workqueue error case
> instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Patch is correct.

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi?hl=en.
For more options, visit https://groups.google.com/groups/opt_out.
