From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Wed, 03 Dec 2014 11:08:23 -0600
Message-ID: <547F4387.5010207@cs.wisc.edu>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu> <52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu> <52CFAA9F.5010706@oracle.com> <52D056E9.8080008@cs.wisc.edu> <52D09CE6.80200@oracle.com> <a90377a8-3ef9-4fc2-a3e9-bfff23560674@googlegroups.com> <547C2E4D.1030802@oracle.com> <E12134C3-7E50-4E13-94FE-7CEDCB7D9537@cs.wisc.edu> <yq17fy9mnsx.fsf@sermon.lab.mkp.net>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBEEH7WRQKGQECKGFVFA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <yq17fy9mnsx.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
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

On 12/2/14, 9:09 PM, Martin K. Petersen wrote:
>>>>>> "Mike" =3D=3D Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> writes:
>
> Mike,
>
> Mike> This was the issue we worked with Microsoft on wasn=E2=80=99t it? Y=
ou guys
> Mike> figured out it was fixed in their target in a recent release
> Mike> right?
>
> The issue we worked recently was wrt. the thin provisioning reporting.
>
> The WRITE SAME problem was that the target returns an iSCSI-specific
> error code rather than a check condition with ILLEGAL REQUEST. You were
> going to talk to MS.

Are you sure about this? The issue you are talking about and the one=20
jazz is is the same issue right?

I do not have any of the old replies from MS, but I have some of the=20
mails I sent them. It looks like we were asking them about when sd.c=20
would send a REPORT SUPPORTED OPERATION, the old MS target would return=20
the iscsi specific error code. And it looks like they had us try a=20
updated version and in there it was changed to just work on their side.

Jazz-jYkeLfz6glqHXe+LvDLADg@public.gmane.org's patch would work around the same problem because in=20
sd_read_write_same, sd would see no_write_same is set and not send=20
REPORT SUPPORTED OPERATION.

The subject of that email thread with MS was "Linux iSCSI and Microsoft=20
target interop question". I started it with MS on Jan 14, 2014. Vaughan=20
ccd you on that thread a little later to get your help. I do not have=20
the replies though. I am just going by truncated snippets in mails sent,=20
so I do not know what version that was fixed in. Do you guys have the=20
replies by any chance?

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
