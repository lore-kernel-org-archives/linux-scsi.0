From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PULL] isci merge candidate
Date: Tue, 17 May 2011 15:11:24 -0700
Message-ID: <BANLkTikt2JgRt0aCcN8NskNEaFXRB_pm8A@mail.gmail.com>
References: <1305317680.21099.83.camel@dwillia2-linux>
	<20110514084949.GA23984@lst.de>
	<1305604567.6008.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305604567.6008.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 16, 2011 at 8:56 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote
> Give me a feel for this: If we put the driver in now, all cleanups
> effectively get postponed until .41 (because they're no longer really
> -rc candidates). =A0If the driver gets included in a .40-rc, we have =
a
> couple more months to get the basic cleanups done.

=2E..all cleanups and the features like atapi support that were deferre=
d
to get this initial cleanup done would be delayed until .41.

> Dan, where's the hardware release at ... as in how urgent is 39-rc la=
st
> vs .40 rc?

Re-reviewed this internally with the latest hardware schedule and it
seems a .40-rc merge is workable.  Especially in light of the caveats
that would be specified for the .39 and .40 version of the driver if
we merged now.

>> And of course there's a lot of room for additional further cleanups
>> that should be able to shave off another couple thousands of lines, =
but
>> these never were on the plate for the initial merge anyway.
>
> Right ... I'm happy with the basic progress so far.

Which achieves the goal of demonstrating that the driver is on a solid
upstream trajectory.  Just need to take the opportunity to get things
finalized properly in .40-rc.

--
Dan
