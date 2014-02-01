From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] cxgb4i: Use cxgb4_select_ntuple to correctly calculate
 ntuple fields
Date: Fri, 31 Jan 2014 23:38:27 -0600
Message-ID: <52EC8853.2010703@cs.wisc.edu>
References: <201401290101.s0T11brL026639@localhost6.localdomain6>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBXEQWKLQKGQEOYZ7BIY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <201401290101.s0T11brL026639-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 1/28/14 7:01 PM, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org wrote:
> [PATCH] cxgb4i: Use cxgb4_select_ntuple to correctly calculate ntuple fields
>
> From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>
> Fixed calculates wrong tuple values on T5 adapter: switch to use the exported API cxgb4_select_ntuple() from cxgb4 base driver.
>
> Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Patch looks ok to me.

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
