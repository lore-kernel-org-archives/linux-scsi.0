From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
Date: Wed, 13 Oct 2010 16:49:22 -0700
Message-ID: <AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
References: <1286977551.2969.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1286977551.2969.22.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> This patch set fixes a couple of longstanding bugs in SCSI. =A0The VP=
D
> patch fix a possible buffer overrun in the VPD code (only tripped if =
the
> device has a huge number of VPD pages). =A0The other is where the sta=
tus
> return code on our BSG interface is wrongly right shifted one place.

Umm. That other patch seems to be utter crap.

> - =A0 =A0 =A0 hdr->device_status =3D status_byte(rq->errors);
> + =A0 =A0 =A0 hdr->device_status =3D rq->errors && 0xff;

That's pure shit. Please look at it for one second, and don't send me
crap like this.

                        Linus "grumpy" Torvalds
