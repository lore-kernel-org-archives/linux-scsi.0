From: Andrew Grover <andy.grover@gmail.com>
Subject: Re: [ACPI] Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 19:47:48 -0800
Message-ID: <c0a09e5c0512091947o4c3d8fd5y10a6b089655d216e@mail.gmail.com>
References: <20051209114246.GB16945@infradead.org> <43997171.9060105@pobox.com>
	 <20051209121124.GA25974@srcf.ucam.org> <439975AB.5000902@pobox.com>
	 <20051209122457.GB26070@srcf.ucam.org> <439A23E8.3080407@pobox.com>
	 <20051210023426.GA31220@srcf.ucam.org> <439A4070.2000500@pobox.com>
	 <20051210025004.GB31328@srcf.ucam.org> <439A4422.3030808@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <439A4422.3030808@pobox.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On 12/9/05, Jeff Garzik <jgarzik@pobox.com> wrote:

> Yes, I do agree with this WRT PATA.  Randy Dunlap's ACPI stuff is
> particularly interesting for this, though I haven't had time to review
> it in depth.
>
> I'm a bit more reluctant WRT SATA.

(side note: Shaohua's patch added ACPI support to PATA. Randy's was
the SATA ACPI support.)

ACPI 3.0 specifically mentions SATA and the control methods that it
expects the OS to make use of: _SDD and _GTF. This is needed for
things like HD password unlocking. So, someone needs to be handling
this whenever the SATA drive is reinitialized, such as on resume. So
there's gotta be some SATA ACPI code, somewhere. (And if there is,
then handling the ICH5 ACPI hotplug interrupt seems like maybe
something it should handle, too.)

I'm sure it's possible to properly abstract things so that
arch-neutral code can remain ACPI-unaware -- I just wanted to make it
clear that even if you don't support ICH5 hotplug there are still ACPI
requirements for SATA.

Regards -- Andy
