From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] isci merge candidate
Date: Fri, 13 May 2011 17:46:10 -0400
Message-ID: <4DCDA6A2.4060001@garzik.org>
References: <1305317680.21099.83.camel@dwillia2-linux> <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, James.Bottomley@hansenpartnership.com, Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 05/13/2011 04:34 PM, Linus Torvalds wrote:
> What's the likely user base of this?

Pretty big, I imagine.

> Why is it a SCSI driver rather
> than SATA?

It's "server" SAS hardware, a la mvsas driver.  SAS hardware is that 
"lovely" superset of SATA + SCSI, where SATA is one of several frame 
formats the device may speak.  So it is definitely a SCSI driver, that 
hooks into SATA processing via ata_sas_* hooks and functions.

> Why is it so f&*%ing big?

1. Because it's a SAS driver :)

2. Because it used to be an ugly vendor driver, now in the process of 
being cleaned up, rather than a nice, clean from-scratch Linux driver.

So it's a bit of a tough call.  It still needs more hammering and 
cleaning, but if this is what winds up on all Intel "server" boards that 
makes it pretty important.

	Jeff
