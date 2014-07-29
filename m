From: Christoph Hellwig <hch@lst.de>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Tue, 29 Jul 2014 14:26:11 +0200
Message-ID: <20140729122611.GA25980@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com> <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com> <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406533762.2003.13.camel@jarvis>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, poma <pomidorabelisima@gmail.com>, Vladimir Davydov <vdavydov@parallels.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 28, 2014 at 11:49:22AM +0400, James Bottomley wrote:
> That needs to be
>=20
> From: James Bottomley <JBottomley@Parallels.com>
>=20
> As well.  I do list handling on hansenpartnership.com to minimise
> exchange wreckage on mailinglists, but I should acknowledge Parallels=
 as
> supporting the work I do.

Thanks, I've update the author, added a Cc to =D1=9Btable and pushed it=
 out to
the core-for-3.17 branch.
