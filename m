From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 16:09:13 -0500
Message-ID: <4398A0F9.9050900@pobox.com>
References: <20051208030242.GA19923@srcf.ucam.org>  <20051208091542.GA9538@infradead.org>  <20051208132657.GA21529@srcf.ucam.org>  <20051208133308.GA13267@infradead.org>  <20051208133945.GA21633@srcf.ucam.org>  <20051208134438.GA13507@infradead.org> <1134062330.1732.9.camel@localhost.localdomain> <43989B00.5040503@pobox.com> <1134075808.43989fa0e0404@www.ijichi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1134075808.43989fa0e0404@www.ijichi.org>
Sender: linux-ide-owner@vger.kernel.org
To: Dominic Ijichi <dom@ijichi.org>
Cc: Erik Slagter <erik@slagter.name>, Christoph Hellwig <hch@infradead.org>, Matthew Garrett <mjg59@srcf.ucam.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Dominic Ijichi wrote:
> Quoting Jeff Garzik <jgarzik@pobox.com>:
> 
> 
>>Erik Slagter wrote:
>>
>>>'guess You're not interested in having suspend/resume actually work on
>>>laptops (or other PC's). That's your prerogative but imho it's a bit
>>>narrow-minded to withhold this functionality from other people who
>>>actually would like to have this working, just because you happen to not
>>>like ACPI.
>>
>>It works just fine on laptops, with Jens' suspend/resume patch.
> 
> 
> not on my fujitsu sonoma/ih6 based laptop it doesn't.  in my travels trying to
> fix this problem it appears there are many others it doesnt work for either. 
> suspend/resume is incredibly important for day-to-day practical use of a laptop,
> particularly using linux. the sole reason i still have a windows partition is
> because suspend doesnt work in linux and i'm sick of firing everything up again
> 3 times a day.
> 
> thank you very much to all on this list who are pursuing a solution sensibly and
> not making unhelpful blanket statements against the most widely used laptop
> chipset maker - *particularly* when they are actively contributing to
> development on this list.  we (laptop users) dont care about religious
> standpoints, we just want it to work.

I've personally tested it on fuji ich5 and ich6 laptops.  What model do 
you have?  What kernel version did you test?  When did you apply the 
suspend/resume patch?

	Jeff



