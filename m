From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: adaptec 2120S software under RedHat 8.0 and FC2
Date: Wed, 23 Mar 2005 10:37:35 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BED3211@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:3280 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261633AbVCWPhh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 10:37:37 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ross Macintyre <raz@macs.hw.ac.uk>, Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, matt_domsch@dell.com

Now you've gone and done it Christoph! ;-}

Christoph Hellwig writes:
> legacy of Adaptec's non linux-supporting past.

Cry with me for a moment... We all know that certification is the real
issue here, most Penguins scoff at this requirement, but customers
expect it none-the-less and pull us through the wringer to provide such
certifications. Christoph, you are on record as not giving a flying fig
for Channel (over the counter) or OEM (complete hardened systems)
customers. There is not even a disagreement between us, as I do in fact
understand your stance; it is merely a matter of which world's we each
must live in.

Adaptec built a complex RAID management tool with a team of hundreds of
engineers and provided a dedicated build system that survives today many
years later still producing Linux products several times a day. The
products are release stabilized, passing through a costly certification
mechanism to OEM clients. Adaptec spilled blood to do this task in the
name of supporting Linux and our customers.

The legacy tools shipped with cards in a 2.4 kernel timeframe based on
Gold Distributions, the users of these legacy cards wish to utilize the
familiar management tools that were shipped with these cards. They can't
because /proc/scsi/aacraid is deprecated. Seems like a simple fix to new
releases of the management tools, but certification testing still has to
occur before release, or our customers will balk. The decision made by
one of our customers recently was to continue to use the legacy
management tools and the Adaptec branch of the Linux driver that
supports /proc/scsi/aacraid to minimize the number of changes and manage
the risks to certification tests.

New tools are developed that continue to support these old cards, these
tools pass through additional Linux Certification testing and release
occurs once the product passes all tests, with a standard of reliability
that our customers expect. But their release is based only on what can
be certified to the satisfaction of our customers, static 'Gold' popular
Distributions laid out on CD which have only recently started to show
2.6 based kernels. Today, our management tools function in said
environments, but they are not to be released until we comply with
existing testing standards.

Thus the explanation for the delay...

And the net result is that every kernel.org customer with less
certification demands that wants our legacy management tools to function
has to come to me to get the latest Adaptec Branch of the aacraid driver
which I gladly and with good temper supply without hesitation, but
leaving me buried trying to keep up. A problem that would go away in a
relative instant if CONFIG_SCSI_PROC_FS was respected for what it was, a
tie-in to legacy support. I, or rather Adaptec that pays my salary, pays
the price for some idealism and Linux support suffers because I have not
got one moment of time left to provide patches for review by MarkH.

I am a Martyr, a bridge to the past, a historian, Christoph! I should be
relished as a hero for all! :-). But I know better than to expect
that...

> note that if adaptec simply opensourced their managment tools we
wouldn't
> have this problem at all. I wonder why Adaptec did that for the old
> i2o-based controllers but not aacraid.  

Oh yes, that, worked hard on the powers-that-be to permit this. Could
not release a substantial majority of it because it would violate
licensed libraries (Zinc, being one of them, I am sorry to admit). So we
release the engine and the raidutil. No logger, no remote communication
engine, no GUI and no browser engine either. It was the best we could
do.

Once released, and under a BSD license, the open source community failed
to contribute one change to the sources. All it did was permit the tools
to be packaged, archived and to continue in-perpetuity when
compatibility libraries failed to work on newer installations.

Why do we not release aaccli & FSAAPI? Gohd knows I've tried. DPT
released products using a Channel paradigm, DKI released products using
an OEM paradigm. It was far easier to release a channel hardened product
with wide OS and platform coverage. But alas, aaccli is no longer
relevant to the new products, and releasing it will only serve to hurt
Adaptec once the customers start utilizing these new products. We know
this through experiences with our customers that have signed NDAs and
are promised engineering support. Heaven forbid us having an uncertified
release mucking around with the reliability...

Adaptec will continue to commit to building and certifying tools that
our customers demand. For those that wish to write their own management
tools, and in an effort to minimize Adaptec's precious engineering
support requirements, Adaptec has instead decided to release a
documented OpenBuild SDK with a consistent management interface for all
our products. The same SDK that our OEM clients get and the same SDK we
use for our own management tools.

It's a baby step in the right direction to satisfy as many as possible.
Look at the definition of politics in the dictionary; it is not an easy
task to please everyone.

> Maybe it still was a DPT management decision?

No, this was almost purely an Adaptec management decision. I can only
find one legacy DPT management signatory to this proposal, and he was
hired on only a matter of months before the DPT purchase and was several
levels down from the top.

Mere coders could work as hard as they want to prod such open releases
along, but remain as JAFO to the likes of CEOs and Directors.

Sincerely -- Mark Salyzyn
