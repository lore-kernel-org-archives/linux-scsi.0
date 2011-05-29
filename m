From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
Date: Sun, 29 May 2011 11:49:08 -0700
Message-ID: <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Gaah.

I don't feel confident or motivated enough about iscsi-target, so
after some (little) thought I ended up not pulling this. I really need
a lot of acks from people who actually work on and care about SCSI,
and right now I feel like with me being away for the next week, I
can't handle it.

I just don't want to be in the situation where I pull something that
is apparently contentious in the SCSI space in general, but that's
_particularly_ true this release. So I'm afraid that this essentially
got pushed out to the next release.

                    Linus

On Fri, May 27, 2011 at 7:59 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Hi Linus,
>
> This is a GIT PULL request for the initial merge of the iscsi-target
> fabric driver for mainline target core v4.0 infrastructure.
>
> =A0git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-=
2.6.git for-40-iscsi-target
>
> This series has been made against the following linux-2.6.git HEAD:
>
> commit dc7acbb2518f250050179c8581a972df3b6a24f1
> Merge: f01e1af 4bf0ff2
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date: =A0 Thu May 26 19:01:15 2011 -0700
>
> =A0 =A0Merge branch 'upstream/tidy-xen-mmu-2.6.39' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/jeremy/xen
>
> This code has undergone a number of review cycles on linux-scsi over =
the
> last six months by Christoph, Mike and other interested folks. =A0Thi=
s has
> included a number of cleanups to follow mainline conventions, and
> conversion to use mainline include/scsi/iscsi_proto.h RFC definitions=
=2E
> There has been an good amount of testing feedback on this code so far=
,
> and with the LIO communities help we have been able to resolve the
> reported cleanup/conversion regressions, and fix one long-standing
> shutdown bug.
>
> Unfortuately James and I have been unable to come to an aggreement on
> implementation details wrt to proper kernel/user split ahead of his
> final SCSI pull for .40. =A0I have no interest to take the mainline
> iscsi-target development effort in this direction again, so I am
> offically committing to you to support iscsi-target in good-faith
> together with rtslib community edition moving forward. =A0I am also
> committing to extending iscsi-target to address the non-standard
> authentication pieces that James has mentioned, but by the time .40
> ships we are still not going to have iSCSI clients that actually supp=
ort
> them.
>
> I believe that Christoph is happy with the current iscsi-target code =
for
> an initial merge now, and am asking for the merge to avoid slipping
> (again) for this type of 'mass-market' code that has a large audience=
,
> and poses minimal risk considering the small amount of external chang=
es.
> [...]
