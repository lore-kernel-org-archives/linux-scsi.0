From: Ilkka Sovanto <ilkka-/1wQRMveznE@public.gmane.org>
Subject: Re: [PATCH] libiscsi: add lock around task lists to fix list
 corruption regression
Date: Fri, 24 Feb 2017 21:48:47 +0200
Message-ID: <CAKYn0tiiUdgpADaAXgepKwLCEsd+N9FbnapbSLKA=4i=pcmaPA@mail.gmail.com>
References: <20170221173536.32024-1-cleech@redhat.com> <250619225.63072551.1487888748696.JavaMail.zimbra@redhat.com>
 <4304a9c0-6427-c0a2-e18a-51292d62022b@linux.vnet.ibm.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=94eb2c03d91aa8523a05494c0480
Return-path: <open-iscsi+bncBD2IVTMGVIKBBIU4YLCQKGQESZOYZFQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <4304a9c0-6427-c0a2-e18a-51292d62022b-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "Guilherme G. Piccoli" <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, martin petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--94eb2c03d91aa8523a05494c0480
Content-Type: text/plain; charset=UTF-8

On Fri, Feb 24, 2017 at 5:09 PM, Guilherme G. Piccoli <
gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> On 02/23/2017 07:25 PM, Chris Leech wrote:
> > Yikes, my git-send-email settings suppressed the important CCs.  Sorry!
> >
> > Guilherme and Ilkka, can you comment about your testing results or
> review please?
>
> Hi Chris, thanks for looping me. Patch seems nice, I do have some points
> below, most nitpicks heheh
> Feel free to accept or not the suggestions!
>
> Hi!

Also testing currently in testing, will try it out in production next if it
looks good. (so far it does). In testing it did hit the warning pretty
quickly.

 - Ilkka

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

--94eb2c03d91aa8523a05494c0480
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Fri, Feb 24, 2017 at 5:09 PM, Guilherme G. Piccoli <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" target=3D"_blank">gpicc=
oli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex"><span class=3D"">On 02/23/2017 07:25 PM, Chris Leech wrote:<br>
&gt; Yikes, my git-send-email settings suppressed the important CCs.=C2=A0 =
Sorry!<br>
&gt;<br>
&gt; Guilherme and Ilkka, can you comment about your testing results or rev=
iew please?<br>
<br>
</span>Hi Chris, thanks for looping me. Patch seems nice, I do have some po=
ints<br>
below, most nitpicks heheh<br>
Feel free to accept or not the suggestions!<br><div class=3D"HOEnZb"><div c=
lass=3D"h5"><br></div></div></blockquote><div>Hi!</div><div><br></div><div>=
Also testing currently in testing, will try it out in production next if it=
 looks good. (so far it does). In testing it did hit the warning pretty qui=
ckly.</div><div><br></div><div>=C2=A0- Ilkka=C2=A0</div></div><br></div></d=
iv>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;open-iscsi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">open-isc=
si+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
To post to this group, send email to <a href=3D"mailto:open-iscsi@googlegro=
ups.com">open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
Visit this group at <a href=3D"https://groups.google.com/group/open-iscsi">=
https://groups.google.com/group/open-iscsi</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

--94eb2c03d91aa8523a05494c0480--
