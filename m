From: Bartlomiej Zolnierkiewicz <bzolnier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 14:22:31 +0100
Message-ID: <58cb370e0512090522h1e6a2c94r45ed652fd3a30da3@mail.gmail.com>
References: <20051208134438.GA13507@infradead.org> <43989B00.5040503@pobox.com>
	 <20051208133144.0f39cb37.randy_d_dunlap@linux.intel.com>
	 <1134121522.27633.7.camel@localhost.localdomain>
	 <20051209103937.GE26185@suse.de>
	 <1134125145.27633.32.camel@localhost.localdomain>
	 <43996A26.8060700@pobox.com>
	 <1134128127.27633.39.camel@localhost.localdomain>
	 <20051209114641.GH26185@suse.de>
	 <20051209115511.GA25842@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20051209115511.GA25842-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Content-Disposition: inline
Sender: acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/acpi-devel>,
	<mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/acpi-devel>,
	<mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=acpi-devel>
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jens Axboe <axboe-l3A5Bk7waGM@public.gmane.org>, Erik Slagter <erik-KW7PGP3XNp7a5EbDDlwbIw@public.gmane.org>, Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, Randy Dunlap <randy_d_dunlap-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 12/9/05, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:
> On Fri, Dec 09, 2005 at 12:46:42PM +0100, Jens Axboe wrote:
> > On Fri, Dec 09 2005, Erik Slagter wrote:
> > > I case this (still) isn't clear, I am addressing the attitude of "It'=
s
> > > ACPI so it's not going to be used, period".
> >
> > The problem seems to be that you are misunderstanding the 'attitude',
> > which was mainly based on the initial patch sent out which stuffs acpi
> > directly in everywhere. That seems to be a good trigger for curt/direct
> > replies.
>
> I was just following the example set by the ide acpi suspend/resume
> patch, which people didn't seem to object to nearly as much. I guess
> IDE's such a hack anyway that people aren't as worried :) I'll try
> produce a patch that just inserts platform-independent code into scsi
> around the start of next week.

Sigh, it seems this is what you get for being nice... ;)

Don't get it wrong IDE people (at least me) are also worried but
they know that there are cases in which ACPI support will help
(even if the main method should be talking to hardware directly)
NOW not in X years when we will have proper, architecture
independent suspend/resume handling (we can live with
"ide_acpi=3Don" kernel parameter before it happens happily).

I also pointed out that I would like to have generic code which
can be shared between libata and IDE drivers (after all both
can provide you with struct pci_dev * and port/device number).

It would be even better if this code will stay in drivers/acpi/ata.c
(?) and libata/IDE will just use the same functions (which will turn
to NOP if CONFIG_ACPI=3Dn) for PATA.

Thanks,
Bartlomiej


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
