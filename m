From: Mark Lord <liml@rtr.ca>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 22:28:38 -0500
Message-ID: <4398F9E6.7000807@rtr.ca>
References: <20051208030242.GA19923@srcf.ucam.org>	 <20051208091542.GA9538@infradead.org>	 <20051208132657.GA21529@srcf.ucam.org>	 <20051208133308.GA13267@infradead.org>	 <20051208133945.GA21633@srcf.ucam.org>	 <20051208134438.GA13507@infradead.org> <1134062330.1732.9.camel@localhost.localdomain> <43989B00.5040503@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43989B00.5040503@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Erik Slagter <erik@slagter.name>, Christoph Hellwig <hch@infradead.org>, Matthew Garrett <mjg59@srcf.ucam.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Erik Slagter wrote:
> 
>> 'guess You're not interested in having suspend/resume actually work on
>> laptops (or other PC's). That's your prerogative but imho it's a bit
>> narrow-minded to withhold this functionality from other people who
>> actually would like to have this working, just because you happen to not
>> like ACPI.
> 
> 
> It works just fine on laptops, with Jens' suspend/resume patch.
> 
>     Jeff

No.  I use it on my two modern laptops with great success,
but only with *certain* hard disks.  When I replace the ultra modern
100GB drive in my machine with a slightly older 30GB drive,
suspend/resume no longer work.  No other changes.

Other users have reported similar experiences to me.

We really REALLY need libata to get fixed for this stuff.

Cheers
