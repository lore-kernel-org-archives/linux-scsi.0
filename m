From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: Thu, 4 Dec 2003 00:21:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <bqlumf$gli$1@news.cistron.nl>
References: <20031203204445.GA26987@gtf.org> <1070494030.15415.111.camel@slurv.pasop.tomt.net> <3FCE737C.1080105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In article <3FCE737C.1080105@pobox.com>,
Jeff Garzik  <jgarzik@pobox.com> wrote:
>Andre Tomt wrote:
>> On Wed, 2003-12-03 at 21:44, Jeff Garzik wrote:
>> 
>>>Intel ICH5
>>>----------
>>>Summary:  No TCQ.  Looks like a PATA controller, but with a few added,
>>>non-standard SATA port controls.
>
>> One question - with "including hotplug", does that mean some set hotplug
>> standard? Reason I'm asking is, we have a few servers from SuperMicro,
>> with a ICH5R S-ATA controller that claims it's supporting hotplug, but
>> hotplug is not in your ICH5-summary.
>
>Alas, there is no hotplug support in the ICH5 or ICH5-R SATA hardware.
>
>One could argue there is "coldplug" support in that hardware -- disable 
>the entire interface, including any active devices, then re-enable and 
>re-scan -- but it's a bit of a hack.  If there's enough demand, I could 
>write some code for that.

Please. Several vendors now have 1U boxes with 2 swappable SATA
drives, and many of those vendors (e.g. supermicro) use
motherboards with the ICH5 SATA chipset.

We're about to buy a few too, and we intend to use the drivers
in RAID0 mode. The ability to swap a drive without powering down
the whole box is quite essential.

Mike.
