From: Tarjei Huse <tarjei@scanventure.no>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Tue, 16 Jan 2007 15:12:58 +0100
Message-ID: <45ACDD6A.7040201@scanventure.no>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net> <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no> <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no> <45A81BBF.7050104@us.ibm.com> <45AA4A7B.7070607@scanventure.no> <45ABE920.7090304@us.ibm.com>
Reply-To: Tarjei Huse <tarjei@nu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.bergfald.no ([213.158.252.226]:1565 "EHLO
	mail2.bergfald.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbXAPONG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2007 09:13:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail2.bergfald.no (Postfix) with ESMTP id BBB46296F71
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 15:13:03 +0100 (CET)
Received: from mail2.bergfald.no ([127.0.0.1])
 by localhost (mail2 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 25138-06 for <linux-scsi@vger.kernel.org>;
 Tue, 16 Jan 2007 15:12:58 +0100 (CET)
Received: from [10.9.1.251] (unknown [10.9.1.251])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.bergfald.no (Postfix) with ESMTP id 27F0B296F61
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 15:12:58 +0100 (CET)
In-Reply-To: <45ABE920.7090304@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Darrick J. Wong wrote:
> Tarjei Huse wrote:
>
>   
>> Duh! Thanks :-)
>>
>> After doing as you suggested, and running make oldconfig using the
>> configuration from Ubuntu Dapper (2.6.15-23-server) and the stock Ubuntu
>> Edgy I get the same error when booting the kernel:
>>
>> PCI: BIOS Bug: MCFG area at e00000000 is not E820-reserved
>> PCI: Not using MMCONFIG
>> PCI Cannot allocate resource region 7 of bridge 0000:00:01.1
>> PCI Cannot allocate resource region 8 of bridge 0000:00:01.1
>> PCI Cannot allocate resource region 9 of bridge 0000:00:01.1
>>     
>
> This is a known conflict between the kernel and the BIOS.  As far as I
> know this should not affect the operation of the aic94xx because it is a
> PCIX device, and bridge 0:0:1.1 is a PCIe port.  At least on the x306m...
>
>   
>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown
>> wn-block(0,0)
>>
>> Is this some missing compile option or a bug?
>>     
>
> Perhaps.  Could you send a full output?  It does not appear that the
> aic94xx driver is loading at all...?
>   
Duh again. I thought I had added the module to the initrd, but that 
didn't happen.

Ok, I'm one step further. Where can I get the binary firmware the 
adapter asks for?

[    2.119258] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    2.119335] ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 19 (level, 
low) -> IRQ 18
[    2.119379] aic94xx: found Adaptec AIC-9405W SAS/SATA Host Adapter, 
device 0000:03:04.0
[    2.119382] scsi0 : aic94xx
[   12.158371] aic94xx: Failed to load sequencer firmware file 
aic94xx-seq-v28.bin, error -2
[   12.158375] aic94xx: couldn't init seqs for 0000:03:04.0
[   12.158376] aic94xx: couldn't init the chip

Kind regards,
Tarjei


> --D
>   

