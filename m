From: "frage schnell" <frage.schnell1@gmx.de>
Subject: Re: sym53c8xx_2 make scsitap slow
Date: Thu, 13 Jan 2005 15:12:27 +0100 (MET)
Message-ID: <20640.1105625547@www29.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:27790 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261630AbVAMOM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 09:12:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 
 
  
>> older SuSE kernel: 
 
>>   Vendor: HP        Model: Ultrium 1-SCSI    Rev: N27D   
>>   Type:   Sequential-Access                  ANSI SCSI revision: 03   
>> sym0:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 15)   
 
>>newer SuSE Linux 9.2 kernel: 
 
>>   Vendor: HP        Model: Ultrium 1-SCSI    Rev: N27D  
>>   Type:   Sequential-Access                  ANSI SCSI revision: 03  
>> scsi(1:0:5:0): Beginning Domain Validation 
>> scsi(1:0:5:0): Ending Domain Validation 
 
>No information on speed here after domain validation? Suspect. 
 
>Is your bus properly terminated (terminator at the end of your cable)? 
>Proper U2W LVD cable in use? 
 
>Or is write validation perhaps stepping on the brake to avoid accidents 
>because the cabling or termination is hosed? 
  
The dmesg outputs with booth kenels ar from today  
from  the same maschine withe te same linux  
 
 
I put a new disk to the same scsi bus  
  the same strange for the tape  
  and the corect one for the disk 
 
 
 
Jan 13 14:54:24 server5 kernel: ACPI: PCI interrupt 0000:02:0c.0[A] -> GSI 
20 (l 
evel, low) -> IRQ 217 
Jan 13 14:54:25 server5 kernel: sym0: <895> rev 0x1 at pci 0000:02:0c.0 
irq 217 
Jan 13 14:54:25 server5 kernel: sym0: Tekram NVRAM, ID 15, Fast-40, LVD, 
parity 
checking 
Jan 13 14:54:25 server5 kernel: sym0: SCSI BUS has been reset. 
Jan 13 14:54:25 server5 kernel: scsi2 : sym-2.1.18j 
Jan 13 14:54:29 server5 kernel:   Vendor: HP        Model: Ultrium 1-SCSI   

Rev 
: N27D 
Jan 13 14:54:29 server5 kernel:   Type:   Sequential-Access                 

ANS 
I SCSI revision: 03 
Jan 13 14:54:29 server5 kernel: scsi(2:0:5:0): Beginning Domain Validation 
Jan 13 14:54:30 server5 kernel: scsi(2:0:5:0): Ending Domain Validation 
Jan 13 14:54:30 server5 kernel: Attached scsi tape st0 at scsi2, channel 
0, id 5 
, lun 0 
Jan 13 14:54:30 server5 kernel: st0: try direct i/o: yes (alignment 512 
B), max 
page reachable by HBA 1048575 
 
 
 
 
Jan 13 14:54:30 server5 kernel: Attached scsi generic sg2 at scsi2, 
channel 0, i 
d 5, lun 0,  type 1 
Jan 13 14:54:30 server5 kernel:   Vendor: IBM       Model: DDYS-T36950N     

Rev: SA2A 
Jan 13 14:54:30 server5 kernel:   Type:   Direct-Access                     

ANSI SCSI revision: 03 
Jan 13 14:54:30 server5 kernel: sym0:6:0: tagged command queuing enabled, 
command queue depth 16. 
 
 
 
Jan 13 14:54:30 server5 kernel: scsi(2:0:6:0): Beginning Domain Validation 
Jan 13 14:54:30 server5 kernel: sym0:6: wide asynchronous. 
Jan 13 14:54:30 server5 kernel: sym0:6: FAST-40 WIDE SCSI 80.0 MB/s ST 
(25.0 ns, offset 31) 
Jan 13 14:54:30 server5 kernel: scsi(2:0:6:0): Ending Domain Validation 
Jan 13 14:54:30 server5 kernel: SCSI device sdc: 71687340 512-byte hdwr 
sectors(36704 MB) 
Jan 13 14:54:30 server5 kernel: SCSI device sdc: drive cache: write back 
Jan 13 14:54:31 server5 kernel:  sdc: unknown partition table 
Jan 13 14:54:31 server5 kernel: Attached scsi disk sdc at scsi2, channel 
0, id 6, lun 0 
Jan 13 14:54:31 server5 kernel: Attached scsi generic sg3 at scsi2, 
channel 0, id 6, lun 0,  type 0 
Jan 13 14:54:41 server5 /etc/dev.d/block/50-hwscan.dev[6547]: new block 
device /block/sdc 
Jan 13 14:54:41 server5 /etc/dev.d/block/51-subfs.dev[6588]: mount block 
device/block/sdc 
Jan 13 14:55:51 server5 kernel: Synchronizing SCSI cache for disk sdc: 
Jan 13 14:55:51 server5 kernel: sym0: detaching ... 
Jan 13 14:55:51 server5 kernel: sym0: resetting chip 
 
 
 
  
 

-- 
+++ Sparen Sie mit GMX DSL +++ http://www.gmx.net/de/go/dsl
AKTION für Wechsler: DSL-Tarife ab 3,99 EUR/Monat + Startguthaben
