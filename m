From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Question regarding SAS controllers.
Date: Sat, 22 Nov 2008 17:28:07 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811221726450.14817@p34.internal.lan>
References: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com> <alpine.DEB.1.10.0811221658280.707@p34.internal.lan> <20081122222120.GA12360@gallifrey>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:35854 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYKVW2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2008 17:28:08 -0500
In-Reply-To: <20081122222120.GA12360@gallifrey>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>



On Sat, 22 Nov 2008, Dr. David Alan Gilbert wrote:

> * Justin Piszcz (jpiszcz@lucidpixels.com) wrote:
>
> <snip>
>
>> Eric,
>>
>> Thanks, I had checked this out earlier but the only non-raid SAS HBAs
>> (those HBAs that do not end in -R) that are JBOD seem to be external only
>> (e.g., do not contain any internal SAS ports?)
>>
>> Justin.
>
> For some of the SAS cards that LSI produce there are 2 sets of firmware
> on their site and you can load the non-RAID firmware; both versions
> will let you drive stuff as individual drives (e.g. tape drives or
> inidivudal discs) but the non-RAID firmware is a LOT faster for that.

Four and eight port LSI cards:
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3041er/index.html
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3081er/index.html

Firmware and BIOS for both Integrated RAID and Initiator-Target.  Must 
boot to DOS to run utility.  Batch file simplifies installation.

Welcome to LSI Logic Integrated SAS Flash Utility
      This Utility will upgrade your LSI SAS3442E HBA

      Integrated RAID ( IR ) or Initiator ( IT ) Firmware

     For IR     Type   R or r
     For IT     Type   T or t
     To Exit    Type   q

So one just needs to flash the card and use the initiator firmware and 
then it will act like a regular (SAS) HBA, no RAID in the card itself, and 
then one, presumably could use the card for md/software raid and have 
direct access to the disks, no need for exporting disks via JBOD etc?

Justin.
