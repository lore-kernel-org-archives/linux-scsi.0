From: Willem Riede <osst-BKTAy3DeTVvYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 24/24] osst: add a SPDX tag to osst.c
Date: Fri, 3 May 2019 09:09:30 -0700
Message-ID: <CAKnBiiYqwPNFU709s8bb+UhX18oqkTRyHpkO2pBAenisHiPUig@mail.gmail.com>
References: <20190501161417.32592-1-hch@lst.de> <20190501161417.32592-25-hch@lst.de>
 <70277444-5b5b-6e3c-5af3-c658a841b144@suse.de> <20190502125312.GA2560@lst.de>
 <10a8c8f5-879c-685f-f43c-d5af678b2187@suse.de> <CAKnBiiaSyW27tCqU4i6zStF3AoLPcndSL2gjz1b17LdoFddiiw@mail.gmail.com>
 <c9a58611-13e2-8e13-b573-b504032c017c@suse.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0000000000006a76a80587fdfab6"
Return-path: <open-iscsi+bncBCNZBX4ASILBB6742DTAKGQE5S3S56Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <c9a58611-13e2-8e13-b573-b504032c017c-l3A5Bk7waGM@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E . J . Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, osst-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chriosstoph Hellwig <hch-+XEJSKglMEw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--0000000000006a76a80587fdfab6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 3, 2019 at 1:05 AM Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org> wrote:

> On 5/2/19 9:55 PM, Willem Riede wrote:
> > On Thu, May 2, 2019 at 7:19 AM Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org
> > <mailto:hare-l3A5Bk7waGM@public.gmane.org>> wrote:
> >
> >      >
> >     Maybe it's time to kill osst.c for good ...
> >
> >
> > Yes. I've been thinking about doing just that. The devices it supports
> > are now thoroughly obsolete. The manufacturer has gone out of business.
> > All my test drives have broken down over time, so I can't even test any
> > changes any more.
> >
> Just when I thought to reach out to you :-)
>
> Thing is, we've done numerous changes to the 'st' driver in the course
> of the years, most of which seem to have avoided osst :-(
>
> So what's your suggestion here?
> Just drop it completely?
> Or can we somehow fold the OnStream-specific things back into st.c?
>
> I sincerely doubt anyone in the entire world still has an Onstream drive
working.
These days cheap flash drives have larger capacity and are way more
convenient.

I recommend to drop osst entirely and not to contaminate st.

Regards, Willem Riede.



> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare-l3A5Bk7waGM@public.gmane.org                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah
> HRB 21284 (AG N=C3=BCrnberg)
>

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
To view this discussion on the web visit https://groups.google.com/d/msgid/=
open-iscsi/CAKnBiiYqwPNFU709s8bb%2BUhX18oqkTRyHpkO2pBAenisHiPUig%40mail.gma=
il.com.
For more options, visit https://groups.google.com/d/optout.

--0000000000006a76a80587fdfab6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;font-size:small"><span style=3D"font-fa=
mily:Arial,Helvetica,sans-serif">On Fri, May 3, 2019 at 1:05 AM Hannes Rein=
ecke &lt;<a href=3D"mailto:hare-l3A5Bk7waGM@public.gmane.org">hare-l3A5Bk7waGM@public.gmane.org</a>&gt; wrote:</span>=
<br></div></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex">On 5/2/19 9:55 PM, Willem Riede wrote:<br>
&gt; On Thu, May 2, 2019 at 7:19 AM Hannes Reinecke &lt;<a href=3D"mailto:h=
are-l3A5Bk7waGM@public.gmane.org" target=3D"_blank">hare-l3A5Bk7waGM@public.gmane.org</a> <br>
&gt; &lt;mailto:<a href=3D"mailto:hare-l3A5Bk7waGM@public.gmane.org" target=3D"_blank">hare@suse=
.de</a>&gt;&gt; wrote:<br>
&gt; <br>&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Maybe it&#39;s time to kill osst.c for good ...<br>
&gt; <br>
&gt; <br>
&gt; Yes. I&#39;ve been thinking about doing just that. The devices it supp=
orts <br>
&gt; are now thoroughly obsolete. The manufacturer has gone out of business=
. <br>
&gt; All my test drives have broken down over time, so I can&#39;t even tes=
t any <br>
&gt; changes any more.<br>
&gt; <br>
Just when I thought to reach out to you :-)<br>
<br>
Thing is, we&#39;ve done numerous changes to the &#39;st&#39; driver in the=
 course <br>
of the years, most of which seem to have avoided osst :-(<br>
<br>
So what&#39;s your suggestion here?<br>
Just drop it completely?<br>
Or can we somehow fold the OnStream-specific things back into st.c?<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">I sincerely doubt anyone in the entire world still=
 has an Onstream drive working.=C2=A0</div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif">These days cheap flash drives=
 have larger capacity and are way more convenient.</div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">I r=
ecommend to drop osst entirely and not to contaminate st.</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">Regards, Willem Riede.</div></div><div><br></div><div>=C2=A0</div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t:1px solid rgb(204,204,204);padding-left:1ex">
Cheers,<br>
<br>
Hannes<br>
-- <br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
Teamlead Storage &amp; Networking<br>
<a href=3D"mailto:hare-l3A5Bk7waGM@public.gmane.org" target=3D"_blank">hare-l3A5Bk7waGM@public.gmane.org</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+49 911 74053 688<br>
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah<br>
HRB 21284 (AG N=C3=BCrnberg)<br>
</blockquote></div></div>

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
To view this discussion on the web visit <a href=3D"https://groups.google.c=
om/d/msgid/open-iscsi/CAKnBiiYqwPNFU709s8bb%2BUhX18oqkTRyHpkO2pBAenisHiPUig=
%40mail.gmail.com?utm_medium=3Demail&utm_source=3Dfooter">https://groups.go=
ogle.com/d/msgid/open-iscsi/CAKnBiiYqwPNFU709s8bb%2BUhX18oqkTRyHpkO2pBAenis=
HiPUig%40mail.gmail.com</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

--0000000000006a76a80587fdfab6--
