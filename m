From: "Joey Lee" <jlee@novell.com>
Subject: Re: [PATCH RFC v2] support SATA ODD zero power
Date: Wed, 08 Dec 2010 10:56:52 -0700
Message-ID: <4D0061940200002300025304@novprvlin0050.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: henry.su.ati@gmail.com, Joey Lee <JLee@novell.com>, James.Bottomley@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,=20

Nice can talk with you! :-)

=E6=96=BC =E4=B8=89=EF=BC=8C2010-12-08 =E6=96=BC 18:25 +0100=EF=BC=8CTe=
jun Heo =E6=8F=90=E5=88=B0=EF=BC=9A
> (cc'ing linux-ide)
>=20
> Hello,
>=20
> On 12/08/2010 04:36 PM, Joey Lee wrote:
> > Dear all expert,=20
> >=20
> > Hi, m... I just google the SATA ODD zero power support and found He=
nry
> > already contribute the patch:
> >=20
> >  http://kerneltrap.org/mailarchive/linux-scsi/2010/6/25/6885558
> >=20
> > And, after first round review,=20
> > The second version is here:
> >  http://www.spinics.net/lists/linux-scsi/msg44925.html
> >=20
> > But, I didn't see this patch merged in kernel maintain, does there =
have
> > any problem with this patch? or actually the patch already in queue
> > waiting to merge to mainline?
> >=20
> > I appreciate if can have any comment to me.
>=20
> IIRC, at the time, the problem was that nobody had the hardware and
> the implementation was solely based on the specification only.  I
> didn't want it to go in without any actual testing, so it was put on
> hold for the time being.  Do you have access to a device with zsero
> power support?  If so, are you willing to test the implementation?
>=20

Got it!
I will do the testing if I get hardware can support this function.

> Hmmm... at the same time, I'm a little bit doubtful about its
> usefulness.  How much power does it save?  Furthermore, ODDs are ofte=
n

I am not sure how many watts can be save, it's need use 2-channel power
meter or NetDAQ to verify. I know how to do that, just need the sample
machine.

> omitted on mobile devices these days.  So, I have a slight reluctance
> against including it but if the implementation is clean enough and
> there is enough benefits it shouldn't be too difficult to overcome.

=46ully understood!


Thank's a lot!
Joey Lee

