From: Yiannis Mavroukakis <jander@darthvader.us>
Subject: Re: legacy megaraid status
Date: Thu, 22 Sep 2005 09:50:38 +0100
Message-ID: <4332705E.6030905@darthvader.us>
References: <433175AE.5070905@darthvader.us> <30E6DB5A16C820CE29D97507@[10.169.6.233]>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail59.messagelabs.com ([195.245.230.83]:17849 "HELO
	mail59.messagelabs.com") by vger.kernel.org with SMTP
	id S1751447AbVIVItw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 04:49:52 -0400
In-Reply-To: <30E6DB5A16C820CE29D97507@[10.169.6.233]>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Kenneth Porter wrote:

> --On Wednesday, September 21, 2005 4:01 PM +0100 Yiannis Mavroukakis 
> <jander@darthvader.us> wrote:
>
>> What is the current situation with the legacy megaraid driver? It seems
>> that is is broken for a lot
>> of people with old raid cards.
>
>
> Any particular card you're interested in?
>
> I've got a test kernel built based on Fedora Core 4's installation 
> kernel to try the new driver with the old i4-100 (ATA100 RAID) but 
> haven't had a chance to build a boot disk with it so I can test it on 
> my working Fedora Core 2 server. (Gotta re-learn how to make boot 
> media. Haven't done that since I made a boot floppy with Red Hat 6.)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This bunny
02:01.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 05) 
(prog-if 01)
        Subsystem: Hewlett-Packard Company HP NetRAID-1Si
        Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ 17
        Memory at fe000000 (32-bit, prefetchable) [size=4M]
        Expansion ROM at <unassigned> [disabled] [size=32K]
        Capabilities: [80] Power Management version 2

I'm stuck with 2.6.11-mm4 at the mo :)

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
