From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] isci merge candidate
Date: Mon, 16 May 2011 20:47:24 -0400
Message-ID: <BANLkTi=yGe+xKpB+VnD3+tvw1-o4Qs_Z7w@mail.gmail.com>
References: <1305317680.21099.83.camel@dwillia2-linux>
	<BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
	<4DCDA663.2040202@intel.com>
	<1305324962.2781.5.camel@pasglop>
	<BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linus Torvalds <torvalds@linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 16, 2011 at 8:39 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> At a minimum It would require a more verbose interface to
> libsas/libata (or new libframe?) to allow us to deliver raw
> unsolicited frames into common protocol handlers.

 ...which is where SAS and SATA have been heading for a while, anyway.
 With chained SAS expander setup you have a network, if an annoying,
manually configured and routed one.  Over that network you deliver
frames of various types.

     Jeff
