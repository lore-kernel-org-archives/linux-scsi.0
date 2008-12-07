From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 18:21:10 +0300
Message-ID: <493BE9E6.7050802@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	 <200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	 <200812062241.35601.bzolnier@gmail.com>	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>	 <493B022B.3050406@ru.mvista.com>	 <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>	 <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:17977 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753914AbYLGPVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Dec 2008 10:21:19 -0500
In-Reply-To: <1228662298.3501.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

Hello.

James Bottomley wrote:

>>>>    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
>>>> for...
>>>>     
>>>>         
>>> Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).
>>>   
>>>       
>>    ATAPI is SCSI transport (with maybe some quirks at SCSI command level 
>> tho, IIRC). ATA is neither thansport nor does it map to SCSI 1:1.
>>     
>
>
> Well, to be wholly accurate, since SCSI-3, SCSI has been separated into
> an architecture, primary command, device specific command and transport
> model (called the SCSI architecture model).

   Thanks, I'm well aware of all this. :-)
   My first encounter with SCSI dates back to 1993-94 -- it's a pity 
that I had to abandon this area (switching to that puny IDE ;-)...

> Starting with ATA-8, ATA
> will go this way again.

   It's gone that way in ATA/PI-7 actually, being broken into 3 separate 
documents then, one spoecifying the command set and 2 others PATA and 
SATA tranports.

>   What ATAPI actually is is a SCSI (really MMC
> for CD and SSC for tape)

   Unfortunately, the initial SFF documents specified both the transport 
protocol and the command sets (which somewhat diverged form what SCSI-2 
had, IIRC).
   Fortunately, once ANSI finally taken over ATAPI work, they dropped 
that stupid practice and started referring to MMC and SSC.

> command transported over ATA using the ATA
> PACKET command.  With ATA-8 it will be much more analogous to SCSI
> command over ATA transport.
>   

    I don't think "analogous" means that it will be sending SCSI CDBs 
over PATA/SATA is of native commands and turn ATA into ATAPI. So all 
this is fine but changes nothing about the SCSI emulation thing.

>> The code for emulating SCSI on ATA only burdens the kernel (and causes user 
>> complaints about changing disk names from /dev/hdx to /dev/sda :-).
>>     
>
> The code for sorting this out is already upstream in the block tree for
> 2.6.29.
>   

   Sorting out what, emulation?

   I have to cut my response short that that point. I must be totally 
crazy to allow myself to be dragged into this discussion having so much 
work to do... :-/

MBR, Sergei


