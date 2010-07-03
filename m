From: Dan Porat <dan.porat@gmail.com>
Subject: Re: 520 BPS data integrity vendors
Date: Fri, 2 Jul 2010 21:03:26 -0400
Message-ID: <AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38291 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0GCBD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2010 21:03:27 -0400
In-Reply-To: <1278093968.2856.169.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jul 2, 2010 at 2:06 PM, James Bottomley <James.Bottomley@suse.d=
e> wrote:
> On Thu, 2010-07-01 at 17:11 -0400, Dan Porat wrote:
>> Hi ,
>>
>> In the documentation of 2.6.34 it says "We have been working with
>> several FC/SAS HBA vendors to enable the protection information to b=
e
>> transferred to and from their controllers"
>> I would like to test SAS 520.
>
> So I'm having a little difficulty parsing this: SAS 520 is actually a
> financial audit standard (which I really wish I didn't know about) ..=
=2E I
> assume you're actually talking about DIF/DIX? =A0The integrity standa=
rd
> for SCSI?
>
>>>You are right on the money.
>>>I mean DIF/DIX .
>>>The final purpose it to run a SATA 520 through a DIF supporting HBA =
, and a SAS/SATA dongle (interposer card).
>>>As initial stage we would like to check SAS DIF field.
>>>Afterwards just put it through a dongle to a SATA 520 sector size dr=
ive.

>> Which Vendor and what specific SAS HBA model will support it ?
>> Thanks
>
> I've added linux-scsi, since this is a SCSI question not an IDE one.
>
> The only SAS HBA supporting DIF I know of with a working Linux driver=
 is
> the mpt2sas. =A0It supports DIF types 1 and 3.
>
>>Would you know of any specific LSI SAS/HBAmodel which will support SC=
SI DIF/DIX ?
> James
>
>
>

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
