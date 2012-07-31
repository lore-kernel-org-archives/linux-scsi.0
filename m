From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Tue, 31 Jul 2012 12:54:51 -0500
Message-ID: <CALAi6FdYPCwo2f-P4+ZMw0hV9hbWDXmvZ9Pa6Sn32-KBYH2kPg@mail.gmail.com>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
 <1343611946.21647.23.camel@pasglop>
 <20120730190606.GD3155@aepfle.de> <1343704122.8227.3.camel@pasglop>
 <501805C3.7030504@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3833946463899347768=="
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <501805C3.7030504@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Olaf Hering <olaf@aepfle.de>, Brian J King <bjking1@us.ibm.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linuxppc-dev@ozlabs.org, Robert C Jennings <rcjenn@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

--===============3833946463899347768==
Content-Type: multipart/alternative; boundary=e89a8fb200fa02f13704c623e0ad

--e89a8fb200fa02f13704c623e0ad
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jul 31, 2012 at 11:20 AM, Brian King <brking@linux.vnet.ibm.com>wrote:

> On 07/30/2012 10:08 PM, Benjamin Herrenschmidt wrote:
> > On Mon, 2012-07-30 at 21:06 +0200, Olaf Hering wrote:
> >>> So while this would work, I do wonder however whether we could
> >> instead
> >>> fix it by simplifying the whole thing as follow since iSeries is now
> >>> gone and so we don't need split backends anymore:
> >>>
> >>> scsi/ibmvscsi: Remove backend abstraction
> >>
> >> I cant that these things myself anymore.
> >
> > Brian, can somebody from your side own these ?
>
> I talked to Rob and he will be picking this up. Rob - can you submit
> a patch to the maintainers file, adding yourself as the ibmvscsi
> maintainer?
>

Submitted a patch for the MAINTAINERS file and I'll take a look at these
patches to verify them as well.  Thanks.

--Rob Jennings

--e89a8fb200fa02f13704c623e0ad
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Tue, Jul 31, 2012 at 11:20 AM, Brian King <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:brking@linux.vnet.ibm.com" target=3D"_=
blank">brking@linux.vnet.ibm.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On 07/30/2012 10:08 PM, Benjamin Herrenschmidt wrote:<br>
&gt; On Mon, 2012-07-30 at 21:06 +0200, Olaf Hering wrote:<br>
&gt;&gt;&gt; So while this would work, I do wonder however whether we could=
<br>
&gt;&gt; instead<br>
&gt;&gt;&gt; fix it by simplifying the whole thing as follow since iSeries =
is now<br>
&gt;&gt;&gt; gone and so we don&#39;t need split backends anymore:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; scsi/ibmvscsi: Remove backend abstraction<br>
&gt;&gt;<br>
&gt;&gt; I cant that these things myself anymore.<br>
&gt;<br>
&gt; Brian, can somebody from your side own these ?<br>
<br>
</div>I talked to Rob and he will be picking this up. Rob - can you submit<=
br>
a patch to the maintainers file, adding yourself as the ibmvscsi maintainer=
?<br></blockquote><div><br></div><div>Submitted a patch for the MAINTAINERS=
 file and I&#39;ll take a look at these patches to verify them as well. =A0=
Thanks.</div>
<div><br></div><div>--Rob Jennings=A0</div></div>

--e89a8fb200fa02f13704c623e0ad--

--===============3833946463899347768==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/linuxppc-dev
--===============3833946463899347768==--
