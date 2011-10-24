From: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in pmcraid_chr_ioctl()
Date: Tue, 25 Oct 2011 01:03:36 +0200
Message-ID: <CAFLxGvwMEmjyifB-_Ms5Xd8iAr+GCVbYk0RX5Qxwev1nyXpFUw@mail.gmail.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	<1319496149.2094.3.camel@Joe-Laptop>
	<CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
	<20111024225459.GB25654@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111024225459.GB25654@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>, richard -rw- weinberger <richard.weinberger@gmail.com>, Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.orglinux
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2011 at 12:54 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Oct 25, 2011 at 12:50:08AM +0200, richard -rw- weinberger wro=
te:
>
> =A0> BTW: What about a checkpatch.pl rule to detect such a misuse of =
kmalloc()?
> =A0> We could grep for "k[mzc]alloc(GFP_".
>
> Make sure to ignore bio_kmalloc (which has reverse argument order to =
kmalloc, ugh)
>

Hmmm, maybe we should "fix" the argument order of bio_kmalloc().
But as this function is exported we'd silently break some out-of-tree
kernel modules....

--=20
Thanks,
//richard
