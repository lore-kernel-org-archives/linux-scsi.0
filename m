From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sat, 19 Aug 2006 07:56:07 -0400
Message-ID: <44E6FC57.5050502@emulex.com>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3745 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1751497AbWHSMLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 08:11:21 -0400
In-Reply-To: <44E68F65.2000701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

How big of a number do you need ?  48 bits ?
We can up to 64bits, but I'd reserve 8bits for a "type" field.
(ugh, sounds like I'm redefining naming authorities...)

On a side thought - is the mac address really the right thing to
use for a vendor id. Wouldn't you be extracting the vendor id from
the mac address ?

-- james

Mike Christie wrote:
> James Smart wrote:
>> +/*
>> + * Vendor ID:
>> + *   If transports post vendor-unique events, they must pass a well-known
>> + *   32-bit vendor identifier. This identifier consists of 8 bits indicating
>> + *   the "type" of identifier contained, and 24 bits of id data.
>> + *
>> + *   Identifiers for each type:
>> + *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
>> + */
>> +#define SCSI_NL_VID_ID_MASK			0x00FFFFFF
>> +#define SCSI_NL_VID_TYPE_MASK			0xFF000000
>> +#define SCSI_NL_VID_TYPE_PCI			0x01000000
>> +
> 
> Would it be possible to make this a little larger? For iscsi we wanted
> to use the MAC address. It can wait. I do not care if it goes in now or
> later. I just don't want to be the first one to break apps by changing
> the number and seeing how many checked version numbers :)
> 
