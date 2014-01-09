From: The Lee-Man <leeman.duncan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Thu, 9 Jan 2014 14:55:29 -0800 (PST)
Message-ID: <d8fa6902-981f-4840-8605-c2f93a32c8b1@googlegroups.com>
References: <52CE77FB.8020100@oracle.com>
 <52CEEC97.8050108@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_189_27095513.1389308129280"
Return-path: <open-iscsi+bncBC755V5RXMKBBYWRXSLAKGQEGXSTPCI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <52CEEC97.8050108-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: vaughan <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

------=_Part_189_27095513.1389308129280
Content-Type: text/plain; charset=ISO-8859-1

On Thursday, January 9, 2014 10:38:15 AM UTC-8, Mike Christie wrote:
>
> ...
>
> > There are some questions: 
> > 1. Why stgt target don't has this issue? Does it support report_opcode 
> > because it has a embeded controller lun0? Or it just returns INVALID in 
> > response? 
>
> Don't know. Will let someone else that works on stgt respond. 
>
>
I just checked https://github.com/fujita/tgt, and it looks like tgtd does 
indeed handle REPORT_SUPPORTED_OPCODES. 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.

------=_Part_189_27095513.1389308129280
Content-Type: text/html; charset=ISO-8859-1

<div dir="ltr">On Thursday, January 9, 2014 10:38:15 AM UTC-8, Mike Christie wrote:<blockquote class="gmail_quote" style="margin: 0;margin-left: 0.8ex;border-left: 1px #ccc solid;padding-left: 1ex;">...<br>
<br>&gt; There are some questions:
<br>&gt; 1. Why stgt target don't has this issue? Does it support report_opcode
<br>&gt; because it has a embeded controller lun0? Or it just returns INVALID in
<br>&gt; response?
<br>
<br>Don't know. Will let someone else that works on stgt respond.
<br>
<br></blockquote><div><br>I just checked https://github.com/fujita/tgt, and it looks like tgtd does indeed handle REPORT_SUPPORTED_OPCODES. <br></div></div>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &quot;open-iscsi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org<br />
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org<br />
Visit this group at <a href="http://groups.google.com/group/open-iscsi">http://groups.google.com/group/open-iscsi</a>.<br />
For more options, visit <a href="https://groups.google.com/groups/opt_out">https://groups.google.com/groups/opt_out</a>.<br />

------=_Part_189_27095513.1389308129280--
