From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: QLA2300, Infortrand and LBD?
Date: Mon, 21 Jun 2004 06:41:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA2043394D@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:9410 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266228AbUFUNlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2004 09:41:12 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "tester7 A." <benew666@hotmail.com>, bugzilla@watkins-home.com
Cc: linux-scsi@vger.kernel.org

I have confirmed on 2.4.20 that the maximum size for a lun is 2 TB.  
Maybe a limitation of the driver's addressing scheme ? Has anyone
tried this with 2.6.x ?  It seems that for 2.4, LVM or MD driver
are your only options.

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>owner@vger.kernel.org] On Behalf Of tester7 A.
>>Sent: Sunday, June 20, 2004 8:25 PM
>>To: bugzilla@watkins-home.com
>>Cc: linux-scsi@vger.kernel.org
>>Subject: RE: QLA2300, Infortrand and LBD?
>>
>>LVM is not an option for  me, because I will not do volume management
for
>>this 3.5TB.
>>
>>Thanks.
>>
>>
>>>From: "Guy" <bugzilla@watkins-home.com>
>>>To: "'tester7 A.'" <benew666@hotmail.com>
>>>Subject: RE: QLA2300, Infortrand and LBD?
>>>Date: Sun, 20 Jun 2004 21:03:44 -0400
>>>
>>>I am not a driver god, so I don't know.  There may be a 2T limit that
>>can't
>>>be crossed.  What about using LVM?
>>>
>>>Send your request back to the list.  Someone should answer, this
seems
>>like
>>>a real good question, or a bug!
>>>
>>>Guy
>>>
>>>-----Original Message-----
>>>From: tester7 A. [mailto:benew666@hotmail.com]
>>>Sent: Sunday, June 20, 2004 8:43 PM
>>>To: bugzilla@watkins-home.com
>>>Subject: RE: QLA2300, Infortrand and LBD?
>>>
>>>Yes. if I split it, it works. But I do not want to use Software RAID0
for
>>>them.
>>>Is there any way to make the kernel recognize the whole volume?
>>>
>>>
>>> >From: "Guy" <bugzilla@watkins-home.com>
>>> >To: "'tester7 A.'" <benew666@hotmail.com>
>>> >Subject: RE: QLA2300, Infortrand and LBD?
>>> >Date: Sun, 20 Jun 2004 12:04:05 -0400
>>> >
>>> >If you can split your ARRAY into 2 logical disks of 1.75TB each, it
may
>>> >work.
>>> >
>>> >-----Original Message-----
>>> >From: linux-scsi-owner@vger.kernel.org
>>> >[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of tester7 A.
>>> >Sent: Sunday, June 20, 2004 4:43 AM
>>> >To: linux-scsi@vger.kernel.org
>>> >Cc: tech@storageone.co.kr
>>> >Subject: QLA2300, Infortrand and LBD?
>>> >
>>> >Hi,
>>> >
>>> >I am using Kernel 2.6.7 and I want to use the Large Block Device
for
>>the
>>> >3.5TB Infortrend FC-Sata RAID.
>>> >
>>> >My H/W is QLA2300, Infortrend A16F-G1A2 FC-SATA RAID, and a Intel
Xeon
>>>SMP
>>> >box.
>>> >
>>> >I also turned on the "LBD support" in the kernel config.
>>> >
>>> >But the kernel recognize only 1.5TB out of 3.5TB, even though it is
one
>>> >volume with 3.5TB.
>>> >
>>> >qla2300 0000:03:09.0: Found an ISP2300, irq 27, iobase 0xf8c5c000
>>> >qla2300 0000:03:09.0: Configuring PCI space...
>>> >qla2300 0000:03:09.0: Configure NVRAM parameters...
>>> >qla2300 0000:03:09.0: Verifying loaded RISC code...
>>> >qla2300 0000:03:09.0: Waiting for LIP to complete...
>>> >qla2300 0000:03:09.0: LIP reset occured (f8f7).
>>> >qla2300 0000:03:09.0: LIP occured (f8f7).
>>> >qla2300 0000:03:09.0: LOOP UP detected (2 Gbps).
>>> >qla2300 0000:03:09.0: Topology - (Loop), Host Loop address 0x0
>>> >scsi3 : qla2xxx
>>> >qla2300 0000:03:09.0:
>>> >QLogic Fibre Channel HBA Driver: 8.00.00b12-k
>>> >   QLogic QLA2310 -
>>> >   ISP2300: PCI-X (66 MHz) @ 0000:03:09.0 hdma-, host#=3,
fw=3.02.28
>>IPX
>>> >   Vendor: IFT       Model: A16F-G1A2         Rev: 334B
>>> >   Type:   Direct-Access                      ANSI SCSI revision:
03
>>> >qla2300 0000:03:09.0: scsi(3:0:0:0): Enabled tagged queuing, queue
>>depth
>>> >32.
>>> >SCSI device sdc: 3022966784 512-byte hdwr sectors (1547759 MB)
>>> >SCSI device sdc: drive cache: write through
>>> >sdc: sdc1
>>> >Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0
>>> >
>>> >Do I need to do something about qla2300 driver or else, in order to
>>make
>>> >the
>>> >
>>> >kernel recognize 3.5TB?
>>> >
>>> >Please help me. Any help will be appreciated.
>>> >
>>> >Thanks in advance.
>>> >
>>> >_________________________________________________________________
>>> >MSN Toolbar provides one-click access to Hotmail from any Web page
-
>>FREE
>>> >download!
http://toolbar.msn.click-url.com/go/onm00200413ave/direct/01/
>>> >
>>> >-
>>> >To unsubscribe from this list: send the line "unsubscribe
linux-scsi"
>>in
>>> >the body of a message to majordomo@vger.kernel.org
>>> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> >
>>> >
>>>
>>>_________________________________________________________________
>>>STOP MORE SPAM with the new MSN 8 and get 2 months FREE*
>>>http://join.msn.com/?page=features/junkmail
>>>
>>>
>>
>>_________________________________________________________________
>>Tired of spam? Get advanced junk mail protection with MSN 8.
>>http://join.msn.com/?page=features/junkmail
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
