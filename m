From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Wed, 03 Dec 2014 17:49:33 -0600
Message-ID: <547FA18D.7030706@cs.wisc.edu>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu>	<52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu>	<52CFAA9F.5010706@oracle.com> <52D056E9.8080008@cs.wisc.edu>	<52D09CE6.80200@oracle.com>	<a90377a8-3ef9-4fc2-a3e9-bfff23560674@googlegroups.com>	<547C2E4D.1030802@oracle.com>	<E12134C3-7E50-4E13-94FE-7CEDCB7D9537@cs.wisc.edu>	<yq17fy9mnsx.fsf@sermon.lab.mkp.net> <547F4387.5010207@cs.wisc.edu> <yq1fvcwl4oy.fsf@sermon.lab.mkp.net>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBFOD72RQKGQEQFKAUHA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <yq1fvcwl4oy.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, jazz-jYkeLfz6glqHXe+LvDLADg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 12/03/2014 05:00 PM, Martin K. Petersen wrote:
> Mike> Jazz-jYkeLfz6glqHXe+LvDLADg@public.gmane.org's patch would work around the same problem because
> Mike> in sd_read_write_same, sd would see no_write_same is set and not
> Mike> send REPORT SUPPORTED OPERATION.
> 
> Yeah. 
> 
> I still don't have a problem quirking the MS target. As long as I can
> get good strings and revs to match on. Obviously setting no_write_same
> for all iSCSI targets is a no-go.

Shooooot, not sure what was tested in that thread now. I tried out the
newer MS iscsi target, 3.3, and still hit the same issue that was
reported here.

What info did you need? Here is vendor/product/version info:

 Vendor identification: MSFT
 Product identification: Virtual HD
 Product revision level: 3.3

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
