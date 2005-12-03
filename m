From: Denny Page <denny@cococafe.com>
Subject: Re: Adaptec aic79xx performance
Date: Sat, 03 Dec 2005 03:04:54 -0800
Message-ID: <43917BD6.8080505@cococafe.com>
References: <439165A1.8070900@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:14218 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S1750824AbVLCLFA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Dec 2005 06:05:00 -0500
Received: from marvin.cococafe.com (gw.cococafe.com [64.142.30.237])
	by mail.cococafe.com (Postfix) with ESMTP id 7EB1F58E
	for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2005 03:04:59 -0800 (PST)
Received: from [192.168.0.10] (daffy.cococafe.com [192.168.0.10])
	by marvin.cococafe.com (Postfix) with ESMTP id 6A13A7FE
	for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2005 03:04:59 -0800 (PST)
In-Reply-To: <439165A1.8070900@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Boot verbose output for the aic79xx controller follows.

Denny

-----

Dec  3 02:46:07 marvin ahd_pci:6:1:0: Reading VPD from 
SEEPROM...ahd_pci:6:1:0: VPD parsing successful
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Reading SEEPROM...done.
Dec  3 02:46:07 marvin ahd_pci:6:1:0: STPWLEVEL is on
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Manual Primary Termination
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Manual Secondary Termination
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Primary High byte termination Disabled
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Primary Low byte termination Enabled
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Secondary High byte termination 
Disabled
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Secondary Low byte termination 
Disabled
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Downloading Sequencer Program... 
650 instructions downloaded
Dec  3 02:46:07 marvin ahd_pci:6:1:0: Features 0x3c001, Bugs 0x500000, 
Flags 0x3d1
Dec  3 02:46:07 marvin scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, 
Rev 1.3.11
Dec  3 02:46:07 marvin <Adaptec 29320ALP Ultra320 SCSI adapter>
Dec  3 02:46:07 marvin aic7901: Ultra320 Wide Channel A, SCSI Id=7, 
PCI-X 101-133Mhz, 512 SCBs
Dec  3 02:46:07 marvin
Dec  3 02:46:07 marvin scsi0: Slave Alloc 0
Dec  3 02:46:07 marvin scsi0: Slave Destroy 0
Dec  3 02:46:07 marvin scsi0: Slave Alloc 1
Dec  3 02:46:07 marvin scsi0: Slave Destroy 1
Dec  3 02:46:07 marvin scsi0: Slave Alloc 2
Dec  3 02:46:07 marvin scsi0: Slave Destroy 2
Dec  3 02:46:07 marvin scsi0: Slave Alloc 3
Dec  3 02:46:07 marvin Vendor: HP        Model: Ultrium 2-SCSI    Rev: F5CD
Dec  3 02:46:07 marvin Type:   Sequential-Access                  ANSI 
SCSI revision: 03
Dec  3 02:46:07 marvin scsi0: Slave Configure 3
Dec  3 02:46:07 marvin target0:0:3: asynchronous.
Dec  3 02:46:07 marvin target0:0:3: Beginning Domain Validation
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending WDTR 1
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received WDTR 1 filtered to 1
Dec  3 02:46:07 marvin target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 
ns, offset 255)
Dec  3 02:46:07 marvin scsi0: target 3 using 16bit transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending SDTR period 44, offset 0
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received SDTR period 44, offset 0
Dec  3 02:46:07 marvin 	Filtered to period 0, offset 0
Dec  3 02:46:07 marvin target0:0:3: wide asynchronous.
Dec  3 02:46:07 marvin scsi0: target 3 using asynchronous transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending WDTR 1
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received WDTR 1 filtered to 1
Dec  3 02:46:07 marvin target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 
ns, offset 255)
Dec  3 02:46:07 marvin scsi0: target 3 using 16bit transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending SDTR period 44, offset 0
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received SDTR period 44, offset 0
Dec  3 02:46:07 marvin 	Filtered to period 0, offset 0
Dec  3 02:46:07 marvin target0:0:3: wide asynchronous.
Dec  3 02:46:07 marvin scsi0: target 3 using asynchronous transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending WDTR 1
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received WDTR 1 filtered to 1
Dec  3 02:46:07 marvin target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 
ns, offset 255)
Dec  3 02:46:07 marvin scsi0: target 3 using 16bit transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending SDTR period 44, offset 0
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received SDTR period 44, offset 0
Dec  3 02:46:07 marvin 	Filtered to period 0, offset 0
Dec  3 02:46:07 marvin target0:0:3: wide asynchronous.
Dec  3 02:46:07 marvin scsi0: target 3 using asynchronous transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending WDTR 1
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received WDTR 1 filtered to 1
Dec  3 02:46:07 marvin target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 
ns, offset 255)
Dec  3 02:46:07 marvin scsi0: target 3 using 16bit transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending SDTR period 44, offset 0
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received SDTR period 44, offset 0
Dec  3 02:46:07 marvin 	Filtered to period 0, offset 0
Dec  3 02:46:07 marvin target0:0:3: wide asynchronous.
Dec  3 02:46:07 marvin scsi0: target 3 using asynchronous transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending WDTR 1
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received WDTR 1 filtered to 1
Dec  3 02:46:07 marvin target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 
ns, offset 255)
Dec  3 02:46:07 marvin scsi0: target 3 using 16bit transfers
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending SDTR period 44, offset 0
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received SDTR period 44, offset 0
Dec  3 02:46:07 marvin 	Filtered to period 0, offset 0
Dec  3 02:46:07 marvin target0:0:3: wide asynchronous.
Dec  3 02:46:07 marvin scsi0: target 3 using asynchronous transfers
Dec  3 02:46:07 marvin target0:0:3: Domain Validation skipping write tests
Dec  3 02:46:07 marvin (scsi0:A:3:0): Sending PPR bus_width 1, period 8, 
offset fe, ppr_options f3
Dec  3 02:46:07 marvin (scsi0:A:3:0): Received PPR width 1, period 9, 
offset fe,options 2
Dec  3 02:46:07 marvin 	Filtered to width 0, period 0, offset 0, options 0
Dec  3 02:46:07 marvin target0:0:3: asynchronous.
Dec  3 02:46:07 marvin scsi0: target 3 using 8bit transfers
Dec  3 02:46:07 marvin target0:0:3: Ending Domain Validation
Dec  3 02:46:07 marvin scsi0: Slave Alloc 4
Dec  3 02:46:07 marvin scsi0: Slave Destroy 4
Dec  3 02:46:07 marvin scsi0: Slave Alloc 5
Dec  3 02:46:07 marvin scsi0: Slave Destroy 5
Dec  3 02:46:07 marvin scsi0: Slave Alloc 6
Dec  3 02:46:07 marvin scsi0: Slave Destroy 6
Dec  3 02:46:07 marvin scsi0: Slave Alloc 8
Dec  3 02:46:07 marvin scsi0: Slave Destroy 8
Dec  3 02:46:07 marvin scsi0: Slave Alloc 9
Dec  3 02:46:07 marvin scsi0: Slave Destroy 9
Dec  3 02:46:07 marvin scsi0: Slave Alloc 10
Dec  3 02:46:07 marvin scsi0: Slave Destroy 10
Dec  3 02:46:07 marvin scsi0: Slave Alloc 11
Dec  3 02:46:07 marvin scsi0: Slave Destroy 11
Dec  3 02:46:07 marvin scsi0: Slave Alloc 12
Dec  3 02:46:07 marvin scsi0: Slave Destroy 12
Dec  3 02:46:07 marvin scsi0: Slave Alloc 13
Dec  3 02:46:07 marvin scsi0: Slave Destroy 13
Dec  3 02:46:07 marvin scsi0: Slave Alloc 14
Dec  3 02:46:07 marvin scsi0: Slave Destroy 14
Dec  3 02:46:07 marvin scsi0: Slave Alloc 15
Dec  3 02:46:07 marvin scsi0: Slave Destroy 15
