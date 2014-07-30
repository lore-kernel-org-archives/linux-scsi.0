From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
Date: Wed, 30 Jul 2014 19:04:59 +0400
Message-ID: <1406732699.4865.92.camel@jarvis>
References: <20140718132104.GK27940@esperanza>
	 <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com>
	 <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	 <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
	 <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis>
	 <20140729122611.GA25980@lst.de>
	 <20140730122135.GE28613@hansolo.jdub.homelinux.org>
	 <20140730145225.GA15757@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45649 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbaG3PFI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 11:05:08 -0400
In-Reply-To: <20140730145225.GA15757@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-scsi@vger.kernel.org, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, poma <pomidorabelisima@gmail.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>

On Wed, 2014-07-30 at 16:52 +0200, Christoph Hellwig wrote:
> On Wed, Jul 30, 2014 at 08:21:35AM -0400, Josh Boyer wrote:
> > > Thanks, I've update the author, added a Cc to =D1=9Btable and pus=
hed it out to
> > > the core-for-3.17 branch.
> >=20
> > This fixes a bug in the 3.16 kernel.  Why wouldn't it be sent to Li=
nus
> > for inclusion in the final release there?
>=20
> I'm only collecting patches for scsi, but James remains formal mainta=
iner, so
> I don't send anything to Linus.  Given that delays between me committ=
ing
> things, them getting picked up by James and finally making it to Linu=
x-next I
> don't feel like another for-3.16 branch at this point is easily worka=
ble.

It's been remarkably current, I believe ... it's already up to date.
However, we only have 2 -next builds between now and the anticipated
3.16 release (unless Linus does another -rc) so there's not enough time
for a patch that isn't already in (although this one is).

> If James wants to cherry pick it and send it on at this time that mig=
ht
> still work fine, but he seems fairly busy.

I'll pull it out and refactor the tree.

James




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
