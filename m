From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: Re: interpreting scsi errors (RAID)
Date: Mon, 9 Feb 2004 16:19:20 -0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2896.137.195.14.4.1076343560.squirrel@www.macs.hw.ac.uk>
References: <2198.137.195.14.4.1076324273.squirrel@www.macs.hw.ac.uk>
    <1076340906.2090.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from izanami.macs.hw.ac.uk ([137.195.13.6]:14977 "EHLO
	izanami.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S263946AbUBIQTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:19:22 -0500
In-Reply-To: <1076340906.2090.3.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


James Bottomley said:
> On Mon, 2004-02-09 at 05:57, Ross Macintyre wrote:
>> I have seen this error twice now:
>>
>> Adapter 1 Channel 1 Target 2: Sense Data: errCode=0x71  valBit=1
>> segMent=0x00  SenseKey=4  ILI=0  EOM=0  FMRK=0  Address=0x00005A8E
>> ASL=0xA  cmdSpec=0x0000  ASC=0x0C  ASCQ=0x00 FRUC Code + Sense Key
>> Specific=0x8001
>
> That's a non recoverable write error.

and do you know if there is any way of knowing what might have caused this?

Cheers,
Ross

>
>> I have an LSILogic Megaraid SCSI 320-1, running RAID level5, 4 disks,
>> and
>> the OS is RedHat8.0.
>>
>> What I would like, is to be able to understand these messages.
>> In particular I need to know if there is a hardware error which means
>> that
>> I can contact the retailer, in confidence, and ask for a replacement, as
>> the disk is still under warranty.
>> Any pointers at FAQs or READMEs greatly appreciated,
>
> All the sense codes are documented in the current SCSI Primary Commands
> document at the t10 webiste
>
> http://www.t10.org/ftp/t10/drafts/spc3/spc3r17.pdf
>
> Although the pointer will change as the standard is revised.
>
> James
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ross Macintyre (raz@macs.hw.ac.uk)
