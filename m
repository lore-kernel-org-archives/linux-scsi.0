From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the 4.14+ merge window
Date: Wed, 31 Jan 2018 11:29:03 -0800
Message-ID: <CA+55aFy4YfNEKiDipUXM_KYR5wen-8hmOp7B7t+=boq14EgdJA@mail.gmail.com>
References: <1517420549.3937.67.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517420549.3937.67.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 31, 2018 at 9:42 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

Ok, now I did indeed get that

  gpg: Can't check signature: unknown pubkey algorithm

because of your fancy new key. But making git use gpg2 indeed fixes
it, since I have a recent enough version.

Let's see if anybody else even notices. I don't think lots of people
look at the signatures.

              Linus
