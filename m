From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Re: Problems getting linux-2.4.31 to detect logical drive on mega
 raid ATA card.
Date: Fri, 04 Nov 2005 10:57:52 -0900
Message-ID: <436BBD40.2030401@aptalaska.net>
References: <0E3FA95632D6D047BA649F95DAB60E5703662C0C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from larry.aptalaska.net ([64.186.96.3]:39127 "EHLO
	larry.aptalaska.net") by vger.kernel.org with ESMTP
	id S1750720AbVKDT6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 14:58:00 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662C0C@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Cc: linux-scsi@vger.kernel.org

Ju, Seokmann wrote:
> On Friday, November 04, 2005 4:05 AM, Matthew Schumacher wrote:
> 
>>At this point I'm not sure what to do.  Any ideas on how to make the
>>newer megaraid driver see the logical drive?
> 
> I assume you are using DELL system.
> Can you provide detail system configuration (like, # of CPU and speed, size
> of memory, MegaRAID ATA controller model, etc)?
> 
> It seems like the kernel (or the driver) is NOT detecting the device for
> some reason. We will post update as we make.
> 
> Thank you,
> 

Thanks for the reply Ju,

Here is the information I have:

System: Power Edge 650
CPU: Intel(R) Pentium(R) 4 CPU 3.06GHz (SMP is on because of the HT cpu)
Memory: 1G (himem enabled)

The controller is:
v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
CERC ATA100/4ch
Controller Type: 438/466/467/471/493/518/520/531/532
Controller Supports 40 Logical Drives
Controller capable of 64-bit memory addressing
Controller is not using 64-bit memory addressing
Base = f89c3000, Irq = 17, Initial Logical Drives = 1, Channels = 4
Version =6.62:1.03, DRAM = 16Mb

The strange part is that the kernel detects the controller, just not the
logical drive on the controller.

Let me know if there is any information I can provide, I would love to
have this working....

schu
