From: sander@elexis.nl
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Thu, 15 Jun 2006 13:20:38 +0200 (CEST)
Message-ID: <17053.82.92.29.80.1150370438.squirrel@webmail.elexis.nl>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
    <20060614224826.GS879@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [83.98.146.225] ([83.98.146.225]:60897 "HELO mx1.elexis.nl")
	by vger.kernel.org with SMTP id S1030217AbWFOLUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 07:20:42 -0400
In-Reply-To: <20060614224826.GS879@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Sander van Beek - Elexis <sander@elexis.nl>, linux-scsi@vger.kernel.org

The FAQ section on the qlogic website says this card is only sold as an
oem product, and that I should contact HP for drivers. However, the driver
packages HP has made available just seem to contain the original qla2xxx
drivers included in the kernel.

Ill post my lspci output somewhere in the next few days, Im not at the
office right now.

Thanks,
Sander

> On Fri, 09 Jun 2006, Sander van Beek - Elexis wrote:
>
>> I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit
>> fibre channel hba's for a pci-x bus. The qlogic site says this type
>> is a HP OEM card and it is not sold directly by qlogic.
>> I tried to get them working on a slackware 10.2 system with the
>> latest stable 2.6 kernel. However, the qla2xxx driver does not see
>> the card. My dmesg only shows this line:
>>
>> Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver
>>
>> This is how the card shows up in my /proc/pci:
>>
>>   Bus  2, device   1, function  1:
>>     Class 0c04: PCI device 1077:8000 (rev 1).
>>       IRQ 255.
>>       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].
>
> btw: can you send the output of 'lspci -vvv' on your machine.
>
> --
> av
>


