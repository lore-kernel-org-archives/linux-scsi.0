From: Christoph Hellwig <hch@lst.de>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Wed, 30 Jul 2014 18:15:17 +0200
Message-ID: <20140730161517.GA22229@lst.de>
References: <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com> <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com> <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis> <20140729122611.GA25980@lst.de> <20140730122135.GE28613@hansolo.jdub.homelinux.org> <20140730145225.GA15757@lst.de> <1406732699.4865.92.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406732699.4865.92.camel@jarvis>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Josh Boyer <jwboyer@fedoraproject.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-scsi@vger.kernel.org, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, poma <pomidorabelisima@gmail.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 30, 2014 at 07:04:59PM +0400, James Bottomley wrote:
> It's been remarkably current, I believe ... it's already up to date.

I've updated the drivers tree today and it will get a few more updates
=E3=81=95oon.

> However, we only have 2 -next builds between now and the anticipated
> 3.16 release (unless Linus does another -rc) so there's not enough ti=
me
> for a patch that isn't already in (although this one is).

Yes, that's why I'm not eager to complicate things.

> > If James wants to cherry pick it and send it on at this time that m=
ight
> > still work fine, but he seems fairly busy.
>=20
> I'll pull it out and refactor the tree.

I'd rather stop rebasing this close to the release.  Linus never had
problems if he got a commit twice due to a cherry pick.
