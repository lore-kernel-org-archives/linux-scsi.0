From: Dominic Ijichi <dom-YBbObg1AmBkdnm+yROfE0A@public.gmane.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 21:34:03 +0000
Message-ID: <1134077643.4398a6cb5bc78@www.ijichi.org>
References: <20051208030242.GA19923@srcf.ucam.org>  <20051208091542.GA9538@infradead.org>  <20051208132657.GA21529@srcf.ucam.org>  <20051208133308.GA13267@infradead.org>  <20051208133945.GA21633@srcf.ucam.org>  <20051208134438.GA13507@infradead.org> <1134062330.1732.9.camel@localhost.localdomain> <43989B00.5040503@pobox.com> <1134075808.43989fa0e0404@www.ijichi.org> <4398A0F9.9050900@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <4398A0F9.9050900-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
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
To: Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Cc: Erik Slagter <erik-KW7PGP3XNp7a5EbDDlwbIw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, randy_d_dunlap-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Quoting Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>:

> Dominic Ijichi wrote:
> > Quoting Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>:
> >
> >
> >>Erik Slagter wrote:
> >>
> >>>'guess You're not interested in having suspend/resume actually work on
> >>>laptops (or other PC's). That's your prerogative but imho it's a bit
> >>>narrow-minded to withhold this functionality from other people who
> >>>actually would like to have this working, just because you happen to not
> >>>like ACPI.
> >>
> >>It works just fine on laptops, with Jens' suspend/resume patch.
> >
> >
> > not on my fujitsu sonoma/ih6 based laptop it doesn't.  in my travels trying
> to
> > fix this problem it appears there are many others it doesnt work for
> either.
> > suspend/resume is incredibly important for day-to-day practical use of a
> laptop,
> > particularly using linux. the sole reason i still have a windows partition
> is
> > because suspend doesnt work in linux and i'm sick of firing everything up
> again
> > 3 times a day.
> >
> > thank you very much to all on this list who are pursuing a solution
> sensibly and
> > not making unhelpful blanket statements against the most widely used laptop
> > chipset maker - *particularly* when they are actively contributing to
> > development on this list.  we (laptop users) dont care about religious
> > standpoints, we just want it to work.
> 
> I've personally tested it on fuji ich5 and ich6 laptops.  What model do
> you have?  What kernel version did you test?  When did you apply the
> suspend/resume patch?

N3510, 60gb sata model.  2.6.14,2.6.15-rc[1..5], with and without mm patches,
and various suspend patches sent to me by people on the linux-ide list.  in
particular, Jens Axboe's libata_suspend.patch and Randy Dunlap's patches here:
http://www.xenotime.net/linux/SATA/2.6.15-rc/, plus patches from your site:
http://www.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.6/.  every
permutation and combination tried!  all with same result - laptop resumes but
hangs on first disk access.

cheers
dom


------------------------------------------
This message was penned by the hand of Dom


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
