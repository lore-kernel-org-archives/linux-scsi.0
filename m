From: Alexy Khrabrov <braver@pobox.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Tue, 22 Oct 2002 18:19:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022221958.GA17112@angle.setup.org>
References: <200210210514.g9L5ElYp006401@angle.badbox.com> <20021021163424.GE28914@redhat.com> <20021022032435.GA11986@angle.setup.org> <3DB4E275.BC760EDE@ix.netcom.com> <20021022161644.GA15234@angle.setup.org> <20021022170316.GA31085@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from alexy@localhost)
	by angle.badbox.com (8.12.5/8.12.5) id g9MMJwMD017500
	for linux-scsi@vger.kernel.org; Tue, 22 Oct 2002 18:19:58 -0400
Content-Disposition: inline
In-Reply-To: <20021022170316.GA31085@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Oct 22, 2002 at 01:03:16PM -0400, Doug Ledford wrote:
> [...] just having the connectors and the SCSI bus itself both inside 
> of a printed circuit board instead of attached to a cable helps them 
> control overall signal quality.

Doug -- thanks for the excellent explanation and a great diagram!
Now it's all clear.  Alas, I don't have a backplane or a place to
stick one to, so I ordered a few recommended sca2lvd adapters --
the one Dan Jones referred to was reported "good" on comp.periphs.scsi
is by Corpsys:

http://www.corpsys.com/store/prodinfo.asp?number=SCA2LVD&variation=&aitem=24&mitem=82

and I also used to like excellent stuff from cablemakers.com, which
is the best place I saw so far for all things SCSI if more expensive --
but those folks put up all the right photos, very professional.  I also
am going to get another adapter from scsisource.com, all different
from the high-bit-squashing Taiwanese piece of art "v1.1" others resell...
I'll report my findings here!

--
Cheers,
Alexy Khrabrov :: www.setup.org :: Age Quod Agis
