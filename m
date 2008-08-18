From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Mon, 18 Aug 2008 10:11:31 -0700 (PDT)
Message-ID: <20080818171131.F3D5E11D107@picon.linux-foundation.org>
References: <bug-11302-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbYHRRMD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2008 13:12:03 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7IHBWbr013669
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2008 10:11:33 -0700
In-Reply-To: <bug-11302-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D11302





------- Comment #5 from pinc_o@yahoo.it  2008-08-18 10:11 -------
Hi Andrew,

I have tryed without load the nvidia module. The problem is the same.

I have attached to this e-mail dmesg output, after some seconds which I=
 have
connected usb card reader, and output of lsmod. I hope you find this us=
eful.
Attach my .config too. Probably is not useful, however you are the expe=
rt ...
I not put everything static, but I put static only things which are alw=
ays in
use and connected to my desktop. Some things which I use only sometime,=
 i.e.
card reader,=C2=A0 then compile it as module. I never use firewire at a=
lI, then I
never compile it. I use this method from ago on the notebook too and al=
ways
work well.

Excuse me for my bad English.


Best Regards

--- Lun 11/8/08, Andrew Morton <akpm@linux-foundation.org> ha scritto:
Da: Andrew Morton <akpm@linux-foundation.org>
Oggetto: Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If I try=
 to
attach an usb card reader, SD, MMC, ecc.. to my Slamd64
A: "Pierre Ossman" <drzeus@drzeus.cx>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
pinc_o@yahoo.it, "James Bottomley" <James.Bottomley@HansenPartnership.c=
om>
Data: Luned=C3=AC 11 agosto 2008, 08:33

On Mon, 11 Aug 2008 07:45:53 +0200 Pierre Ossman <drzeus@drzeus.cx> wro=
te:

> On Sun, 10 Aug 2008 13:53:44 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>=20
> >=20
> > (switched to email.  Please respond via emailed reply-to-all, not v=
ia
the
> > bugzilla web interface).
> >=20
> > On Sun, 10 Aug 2008 13:45:49 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:
> >=20
> > > http://bugzilla.kernel.org/show_bug.cgi?id=3D11302
> > >=20
> > >            Summary: I get a kernel OOPS! If I try to attach an
usb card
> > >                     reader, SD, MMC, ecc.. to my Slamd64
> > >            Product: IO/Storage
> > >            Version: 2.5
> > >      KernelVersion: 2.6.26.2
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: blocking
> > >           Priority: P1
> > >          Component: SCSI
> > >         AssignedTo: linux-scsi@vger.kernel.org
> > >         ReportedBy: pinc_o@yahoo.it
> >=20
> > Is this a scsi regresion, or an mmc regression?
> >=20

OK.  There have been some regressions in the scsi area but I thought
that a) they were fixed and b) none manifested as an oops in
slave_alloc().

Perhaps James can take a look please?

> There are no USB based "real" MMC controllers, so I'd say
SCSI.
>=20
> > > If attach my usb card reader, without load mmc_block an mmc_core
modules, then
> > > the follow OOPS appear(If first load them, simply doesn't
mount the SD. Please
> > > note: I always use "automatic loading kernel modules"
compiled in "my" kernelS.
> > > But from many time, the recent kernelS not load the mmc_block
module):
>=20
> I don't know what kind of weird ass scripts loaded them for USB mass
> storage to begin with. As for the claimed lack of crashes when loaded=
;
> no idea as there is no interaction between the SCSI and MMC layer.
>=20
> > > Modules linked in: nvidia(P) [last unloaded: nvidia]
>=20
> This is always a good start..

I very much doubt it.

Paolo, can you please check to see if the crash happens in a kernel
into which the nvidia driver has never been loaded?




      Posta, news, sport, oroscopo: tutto in una sola pagina.=20
Crea l&#39;home page che piace a te!
www.yahoo.it/latuapagina<table cellspacing=3D"0" cellpadding=3D"0" bord=
er=3D"0"
><tr><td valign=3D"top" style=3D"font: inherit;">Hi Andrew,<br><br>I ha=
ve tryed
without load the nvidia module. The problem is the same.<br><br>I have =
attached
to this e-mail dmesg output, after some seconds which I have connected =
usb card
reader, and output of lsmod. I hope you find this useful. Attach my .co=
nfig
too. Probably is not useful, however you are the expert ...<br>I not pu=
t
everything static, but I put static only things which are always in use=
 and
connected to my desktop. Some things which I use only sometime, i.e. ca=
rd
reader,&nbsp; then compile it as module. I never use firewire at alI, t=
hen I
never compile it. I use this method from ago on the notebook too and al=
ways
work well.<br><br>Excuse me for my bad English.<br><br><br>Best
Regards<br><br>--- <b>Lun 11/8/08, Andrew Morton
<i>&lt;akpm@linux-foundation.org&gt;</i></b> ha scritto:<br><blockquote
style=3D"border-left: 2px solid rgb(16, 16,
 255); margin-left: 5px; padding-left: 5px;">Da: Andrew Morton
&lt;akpm@linux-foundation.org&gt;<br>Oggetto: Re: [Bugme-new] [Bug 1130=
2] New:
I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ec=
c.. to
my Slamd64<br>A: "Pierre Ossman" &lt;drzeus@drzeus.cx&gt;<br>Cc:
linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, pinc_o@ya=
hoo.it,
"James Bottomley" &lt;James.Bottomley@HansenPartnership.com&gt;<br>Data=
:
Luned=C3=AC 11 agosto 2008, 08:33<br><br><pre>On Mon, 11 Aug 2008 07:45=
:53 +0200
Pierre Ossman &lt;drzeus@drzeus.cx&gt; wrote:<br><br>&gt; On Sun, 10 Au=
g 2008
13:53:44 -0700<br>&gt; Andrew Morton &lt;akpm@linux-foundation.org&gt;
wrote:<br>&gt; <br>&gt; &gt; <br>&gt; &gt; (switched to email.  Please =
respond
via emailed reply-to-all, not via<br>the<br>&gt; &gt; bugzilla web
interface).<br>&gt; &gt; <br>&gt; &gt; On Sun, 10 Aug 2008 13:45:49 -07=
00
(PDT)<br>bugme-daemon@bugzilla.kernel.org wrote:<br>&gt; &gt; <br>&gt; =
&gt;
&gt;
 http://bugzilla.kernel.org/show_bug.cgi?id=3D11302<br>&gt; &gt; &gt; <=
br>&gt;
&gt; &gt;            Summary: I get a kernel OOPS! If I try to attach a=
n<br>usb
card<br>&gt; &gt; &gt;                     reader, SD, MMC, ecc.. to my
Slamd64<br>&gt; &gt; &gt;            Product: IO/Storage<br>&gt; &gt; &=
gt;    =20
      Version: 2.5<br>&gt; &gt; &gt;      KernelVersion: 2.6.26.2<br>&g=
t; &gt;
&gt;           Platform: All<br>&gt; &gt; &gt;         OS/Version:
Linux<br>&gt; &gt; &gt;               Tree: Mainline<br>&gt; &gt; &gt; =
       =20
   Status: NEW<br>&gt; &gt; &gt;           Severity: blocking<br>&gt; &=
gt; &gt;
          Priority: P1<br>&gt; &gt; &gt;          Component: SCSI<br>&g=
t; &gt;
&gt;         AssignedTo: linux-scsi@vger.kernel.org<br>&gt; &gt; &gt;  =
     =20
ReportedBy: pinc_o@yahoo.it<br>&gt; &gt; <br>&gt; &gt; Is this a scsi
regresion, or an mmc regression?<br>&gt; &gt; <br><br>OK.  There have b=
een some
regressions in the scsi area but I
 thought<br>that a) they were fixed and b) none manifested as an oops
in<br>slave_alloc().<br><br>Perhaps James can take a look please?<br><b=
r>&gt;
There are no USB based "real" MMC controllers, so I'd say<br>SCSI.<br>&=
gt;
<br>&gt; &gt; &gt; If attach my usb card reader, without load mmc_block=
 an
mmc_core<br>modules, then<br>&gt; &gt; &gt; the follow OOPS appear(If f=
irst
load them, simply doesn't<br>mount the SD. Please<br>&gt; &gt; &gt; not=
e: I
always use "automatic loading kernel modules"<br>compiled in "my"
kernelS.<br>&gt; &gt; &gt; But from many time, the recent kernelS not l=
oad the
mmc_block<br>module):<br>&gt; <br>&gt; I don't know what kind of weird =
ass
scripts loaded them for USB mass<br>&gt; storage to begin with. As for =
the
claimed lack of crashes when loaded;<br>&gt; no idea as there is no int=
eraction
between the SCSI and MMC layer.<br>&gt; <br>&gt; &gt; &gt; Modules link=
ed in:
nvidia(P) [last unloaded: nvidia]<br>&gt; <br>&gt; This is always
 a good start..<br><br>I very much doubt it.<br><br>Paolo, can you plea=
se check
to see if the crash happens in a kernel<br>into which the nvidia driver=
 has
never been loaded?<br><br></pre></blockquote></td></tr></table><br>




      <hr size=3D1>
Posta, news, sport, oroscopo: tutto in una sola pagina<br> <a =20
href=3D"http://us.rd.yahoo.com/mailuk/taglines/isp/control/*http://us.r=
d.yahoo.com/evt=3D52437/*http://www.yahoo.it/latuapagina"
target=3D_blank>Crea l&#39;home page che piace a te!</a>.


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
