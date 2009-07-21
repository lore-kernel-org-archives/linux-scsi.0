From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: mptspi: Unexpected doorbell active!
Date: Tue, 21 Jul 2009 15:29:59 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A3569E1@inbmail01.lsi.com>
References: <4A54B611.2030802@interlog.com>
 <1247067320.4159.162.camel@mulgrave.site> <4A565620.5060007@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:32798 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZGUKAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 06:00:07 -0400
In-Reply-To: <4A565620.5060007@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Can you provide dmesg log with log level enable to 0x8188.

"echo 0x8188 > /sys/class/scsi_host/hostX/debug_level"

Thanks,
Kashyap

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Douglas Gilbert
Sent: Friday, July 10, 2009 2:12 AM
To: James Bottomley
Cc: linux-scsi@vger.kernel.org
Subject: Re: mptspi: Unexpected doorbell active!

James Bottomley wrote:
> On Wed, 2009-07-08 at 17:06 +0200, Douglas Gilbert wrote:
>> Cute error message but it appears just before my machine
>> locks solid. It looks like it is coming from a LSI 53c1030
>> SPI controller which lspci says is PCI-X but is actually
>> PCIe.
>>
>> I get that with 2 different tape drives (LTO-1 and LTO-3)
>> whose true identities are hidden behind badge engineering,
>> Tandberg data perhaps? Anyway both seem to have a major
>> problem with the LOG SENSE command and the Tape Alert
>> page in particular.
>>
>> The lockup occurs with both a Debian Lenny standard kernel
>> (lk 2.6.26-2-686) and a kernel.org lk 2.6.30 .
> 
> So the problem has been around for a while ...
> 
>> There is nothing other than the 53c1030 and a single tape
>> drive on the SCSI bus. So there is no good reason to lock
>> up the machine for any SCSI related error.
> 
> LSI just reworked the code that does this doorbell handling for the
> 2.6.31 merge window could you see if 2.6.31-rc2 is still exhibiting the
> problem?

Yes it is.

The controller is a LSI20320IE and the main chip appears
to be a LSI53C1020A A1.

Doug Gilbert


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
