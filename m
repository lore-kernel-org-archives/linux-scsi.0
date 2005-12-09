From: Jens Axboe <axboe-l3A5Bk7waGM@public.gmane.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 12:30:53 +0100
Message-ID: <20051209113053.GG26185@suse.de>
References: <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org> <20051208134438.GA13507@infradead.org> <1134062330.1732.9.camel@localhost.localdomain> <43989B00.5040503@pobox.com> <20051208133144.0f39cb37.randy_d_dunlap@linux.intel.com> <1134121522.27633.7.camel@localhost.localdomain> <20051209103937.GE26185@suse.de> <1134125145.27633.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1134125145.27633.32.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/acpi-devel>,
	<mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/acpi-devel>,
	<mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=acpi-devel>
To: Erik Slagter <erik-KW7PGP3XNp7a5EbDDlwbIw@public.gmane.org>
Cc: Randy Dunlap <randy_d_dunlap-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 09 2005, Erik Slagter wrote:
> On Fri, 2005-12-09 at 11:39 +0100, Jens Axboe wrote:
> 
> > > IMHO available infrastructure (and hardware abstraction!) should be used
> > > instead of being stubborn and pretend we know everything about any
> > > hardware.
> > 
> > It's not about being stubborn, it's about maintaining and working on a
> > clean design. The developers have to do that, not the users. So forgive
> > people for being a little cautious about shuffling all sorts of ACPI
> > into the scsi core and/or drivers. We always need to think long term
> > here.
> > 
> > Users don't care about the maintainability and cleanliness of the code,
> > they really just want it to work. Which is perfectly understandable.
> 
> I perfectly understand that, what I do object against, is rejecting a
> concept (like this) totally because the developers(?) do not like the
> mechanism that's used (although ACPI is used everywhere else in the
> kernel). At least there might be some discussion where this sort of code
> belongs to make the design clean and easily maintainable, instead of
> instantly completely rejecting the concept, because OP simply doesn't
> like acpi.

Not to put words in anyones mouth, but the rejection is mainly based on
the concept of stuffing acpi directly into the SCSI core where it
clearly doesn't belong. I don't think anyone is against utilizing ACPI
(if useful/required) for suspend+resume as a concept, even if lots of
people have reservations on ACPI in generel.

-- 
Jens Axboe



-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
