From: Michael Clark <michael@metaparadigm.com>
Subject: Re: Hot plugging a disk in runtime
Date: Tue, 21 May 2002 23:42:37 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CEA6AED.5040704@metaparadigm.com>
References: <200205201420.g4KEK3x01892@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Rabeeh Khoury <rabeeh@galileo.co.il>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>



On 05/20/02 22:20, James Bottomley wrote:

[snip]

>This is the province of something called the Scsi Enclosure Services (SES) 
>standard:
>
>ftp://ftp.t10.org/t10/drafts/ses/ses-r08b.pdf
>
>However, like most standards it began life as a bunch of companies each 
>inventing their own more or less proprietary way of doing things and then 
>realising that standardisation might be a good thing, so there are quite a few 
>not quite compatible implementations of this.
>
>Like all good standards it's also due to be superceded (by SES-2) any day now.
>
>There is an enclosure monitor, which I haven't looked at but which I presume 
>could be used as part of a hotplug system for SCSI devices:
>
>http://gort.metaparadigm.com/saftemon/
>  
>
saftemon currently only does SAF-TE and not SES - but if you have a SAF-TE
enclosure, it will give you an event when a disk has been inserted into an
empty slot (or removed).

There is even some (currently not activated) code in there to map SAF-TE
slots to the corresponding Linux SCSI device. This of course only works if
you have physical disk devices on the SCSI bus as logical (RAID) devices
can't be correllated easily to device slots (not unless you have an API 
to do
get the mappings from your RAID controller).

It would be quite nice to get saftemon events to trigger Software RAID
commands in a Software RAID set-up such as doing a device probe and
maybe a raid hot add when a new disk is inserted.

~mc

