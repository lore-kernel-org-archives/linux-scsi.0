From: Alexy Khrabrov <braver@pobox.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Mon, 21 Oct 2002 22:00:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022020058.GA11546@angle.setup.org>
References: <200210210514.g9L5ElYp006401@angle.badbox.com> <20021021163424.GE28914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021021163424.GE28914@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>, linux-scsi@vger.kernel.org

On Mon, Oct 21, 2002 at 12:34:24PM -0400, Doug Ledford wrote:
> On Mon, Oct 21, 2002 at 01:14:47AM -0400, Alexy Khrabrov wrote:
> > 
> > Greetings -- did anybody try to connect a SCSI SCA
> > hard drive (with 80 pins) to an Adaptec 7899
> > Ultra160 with 65 pins?  Mine seems unable to spin
> > them at 160 Mbps.
> 
> [ snip long description ]
> 
> There is no difference between 68 pin drives and 80 pin drives as far as 
> the controller and the drive are concerned.  It's all just a physical 
> interconnect difference.  The problem you are describing is a 
> non-functional SCA->wide adapter.  I have yet to ever find a simple 
> wide<->SCA adapter that worked.  I've always had to have a real SCA 
> backplane before things worked properly.
> 

Thanks Doug.  Justin Gibbs concurred.  I am wondering whether the curse
is complete or anybody could recommend an adapter/enclosure?  I was
googling around and found things like CRU dataport racks, InClose 
external enclosures, and cremax racks, all having a 80<->68 model.
Now these things looks like more professional, and at least there's
a manufacturer as opposed to the anonymous Taiwan-made 80<->68 adapter.
Any experience with any of these stuffed with SCA drives connected to
a 68 pin Ultra160?...
-- 
Cheers,
Alexy Khrabrov :: www.setup.org :: Age Quod Agis
