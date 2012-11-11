From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: scsi target, likely GPL violation
Date: Sun, 11 Nov 2012 08:05:53 -0500
Message-ID: <20121111130553.GA30943@thunk.org>
References: <509A915B.30105@redhat.com>
 <1352626456.6524.46.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352626456.6524.46.camel@dabdike>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>, "Bradley M. Kuhn" <bkuhn@sfconservancy.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 11, 2012 at 09:34:16AM +0000, James Bottomley wrote:
> Anybody who does enforcement will tell you that you begin with first
> hand proof of a violation.  That means obtain the product and make sure
> it's been modified and that a request for corresponding source fails.
> In this case, since I presume Red Hat, as a RTS partner, has a bona fide
> copy of the RTS OS, please verify it does indeed implement or issue the
> commands which are not in the public git repository and that whoever
> owns the copy makes a request for the source code.

It should also be noted (although I have no idea if this is what is
going on here; this is a generalized statement and not one where I
have attempted to apply the facts to the law --- that requires the
expertise of a lawyer, and please let's not play lawyer on LKML)
that it *is* possible for the copyright owner to license the code
under more than once license.  Yes, once the code has been contributed
to a GPL'ed project, and changes have been accepted from other people
which touch said code, things get muddied --- but if someone were to
keep an original copy of the code where they own 100% of all of the
lines of code, and then use that in a proprietary project, that can be
perfectly OK from a copyright perspective.

(I say this speaking as someone who once did exactly this with the
resizing code found in e2fsprogs.  That work was sponsored and was
made possible by the company which wrote Partition Magic, a long time
ago, and the work-for-hire contract I signed with them precisely
spelled out how it could be released for commercial use as well as
under the GPL.  As far as I know they may still be shipping resizing
code for ext2 and ext3 --- but not ext4, since those changes were
contributed later, under a GPL-only license.)

The bottom line is that copyright licensing can get *complicated* and
so before you start flinging about accusations, one would be wise to
be 100% sure of the facts.  You need to make sure that they have
distributed lines of code which came from the *Linux* kernel, and not
just from code which they may have originally contributed to the Linux
kernel.

Best regards,

					- Ted
