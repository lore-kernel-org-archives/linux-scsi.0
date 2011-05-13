From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [GIT PULL] isci merge candidate
Date: Sat, 14 May 2011 08:16:02 +1000
Message-ID: <1305324962.2781.5.camel@pasglop>
References: <1305317680.21099.83.camel@dwillia2-linux>
	 <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
	 <4DCDA663.2040202@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DCDA663.2040202@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org


> It's a SAS (serial-attached-scsi) driver so it ties in to libsas rather 
> than libata (libsas itself ties in to libata for tunnelling SATA 
> protocol over SAS).  The size is attributable to the fact that all 
> protocol handling for non-fast path i/o is handled by software.  There 
> are still cleanups that can be made, but likely not on the on the same 
> order of what we have already done.

How much of that non-fast-path could/should be in generic code vs. in
the driver specific code ? IE. If somebody comes up with another "dumb"
SAS adapter tomorrow that doesn't do all that magic in an offload CPU,
is any of that code re-usable ?

Cheers,
Ben.
