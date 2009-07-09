From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: mptspi: Unexpected doorbell active!
Date: Thu, 09 Jul 2009 22:42:08 +0200
Message-ID: <4A565620.5060007@interlog.com>
References: <4A54B611.2030802@interlog.com> <1247067320.4159.162.camel@mulgrave.site>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40442 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZGIUmN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 16:42:13 -0400
In-Reply-To: <1247067320.4159.162.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

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


