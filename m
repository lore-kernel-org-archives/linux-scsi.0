From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH]: Fix Ultrastor asm snippet
Date: Fri, 20 May 2011 15:04:17 +0200
Message-ID: <20110520130417.GO5077@const.bordeaux.inria.fr>
References: <20110518150605.GA25262@const.bordeaux.inria.fr> <20110520130215.GB3428@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110520130215.GB3428@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, le Fri 20 May 2011 09:02:15 -0400, a =E9crit :
> On Wed, May 18, 2011 at 05:06:05PM +0200, Samuel Thibault wrote:
> > Commit 1292500b replaced
> >=20
> > "=3Dm" (*field) : "1" (*field)
> >=20
> > with
> >=20
> > "=3Dm" (*field) :
> >=20
> > with comment "The following patch fixes it by using the '+' operato=
r on
> > the (*field) operand, marking it as read-write to gcc."
> > '+' was actually forgotten.  This really puts it.
>=20
> Do you actually have the hardware or was this just a code audit?

Just a code audit.

> I have the strong suspicion that this driver is pretty much dead and
> bitrotting.

Most probably, yes.

Samuel
