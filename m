From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 77631] task scsi_eh_6:537 blocked for more than 120 seconds.
Date: Tue, 10 Jun 2014 21:49:27 +0000
Message-ID: <bug-77631-11613-ejs8t6NlWs@https.bugzilla.kernel.org/>
References: <bug-77631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbaFJVtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 17:49:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BA6CA202DD
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 21:49:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AF0342028D
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 21:49:27 +0000 (UTC)
In-Reply-To: <bug-77631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=77631

--- Comment #3 from Mikhail <mikhail.v.gavrilov@gmail.com> ---
When I reconnect my USB3.0 10 port hub only occurs this:

[  835.657491] usb 4-3: USB disconnect, device number 3
[  835.657506] usb 4-3.4: USB disconnect, device number 11
[  835.658118] usb 4-3.4: Failed to set U1 timeout to 0x0,error code -19
[  835.658134] usb 4-3.4: Failed to set U1 timeout to 0x43,error code -19
[  835.658146] usb 4-3.4: Failed to set U2 timeout to 0x28,error code -19
[  835.694393] usb 4-3.4: Failed to set U1 timeout to 0x0,error code -19
[  835.694434] usb 4-3.4: Failed to set U1 timeout to 0x29,error code -19
[  835.694440] usb 4-3.4: Failed to set U2 timeout to 0x28,error code -19
[  835.802188] usb 3-3: USB disconnect, device number 11
[  835.802191] usb 3-3.1: USB disconnect, device number 12
[  835.802193] usb 3-3.1.3: USB disconnect, device number 14
[  835.868161] usb 3-3.1.4: USB disconnect, device number 15
[  835.875955] usb 3-3.1.6: USB disconnect, device number 16
[  835.914734] usb 3-3.3: USB disconnect, device number 13
[  841.411016] usb 3-7: USB disconnect, device number 3
[  859.635511] usb 3-7: new high-speed USB device number 20 using xhci_hcd
[  859.800823] usb 3-7: New USB device found, idVendor=2109, idProduct=2812
[  859.800833] usb 3-7: New USB device strings: Mfr=0, Product=1,
SerialNumber=0
[  859.800838] usb 3-7: Product: USB 2.0 HUB

[  859.803390] hub 3-7:1.0: USB hub found
[  859.803648] hub 3-7:1.0: 4 ports detected
[  860.088189] usb 3-7.1: new high-speed USB device number 21 using xhci_hcd
[  860.174264] usb 3-7.1: New USB device found, idVendor=1a40, idProduct=0201
[  860.174266] usb 3-7.1: New USB device strings: Mfr=0, Product=1,
SerialNumber=0
[  860.174268] usb 3-7.1: Product: USB 2.0 Hub [MTT]
[  860.174915] hub 3-7.1:1.0: USB hub found
[  860.174941] hub 3-7.1:1.0: 7 ports detected
[  860.251194] usb 3-7.3: new high-speed USB device number 22 using xhci_hcd
[  860.338906] usb 3-7.3: New USB device found, idVendor=18d1, idProduct=4ee1
[  860.338908] usb 3-7.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  860.338909] usb 3-7.3: Product: Nexus 5
[  860.338910] usb 3-7.3: Manufacturer: LGE
[  860.338911] usb 3-7.3: SerialNumber: 07606f5400e1b31a
[  860.375934] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.375967] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376052] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376646] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376686] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376723] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376763] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376803] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376906] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.376942] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377140] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377215] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377254] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377369] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377451] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377494] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377534] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377570] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377651] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377693] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377745] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.377828] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378002] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378120] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378160] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378198] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378240] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378279] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378320] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378363] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378414] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378455] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378501] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378665] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378704] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378747] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378787] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378828] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378881] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378920] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.378970] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379011] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379049] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379211] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379248] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379329] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379408] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379489] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379530] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379574] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379651] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379731] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379768] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379889] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.379979] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380011] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380086] xhci_hcd 0000:00:14.0: URB transfer length is wrong, xHC issue?
req. len = 4, act. len = 4294967292
[  860.380095] hub 3-7.1:1.0: hub_port_status failed (err = 0)
[  860.380131] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380316] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380358] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380437] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380480] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380518] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380678] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380716] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380797] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380881] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380918] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.380965] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381036] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381119] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381158] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381198] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381318] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381358] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381436] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381519] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381557] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381640] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381680] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381757] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381801] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381848] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.381996] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382129] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382163] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382241] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382328] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382366] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382447] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382495] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382533] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382574] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382694] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382733] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382773] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382854] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382899] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.382938] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383019] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383065] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383106] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383145] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383306] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383349] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383423] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383466] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383502] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383583] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383625] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383704] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383742] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383787] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383945] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.383982] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384055] xhci_hcd 0000:00:14.0: URB transfer length is wrong, xHC issue?
req. len = 4, act. len = 4294967292
[  860.384121] hub 3-7.1:1.0: hub_port_status failed (err = 0)
[  860.384161] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384201] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384244] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384279] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384360] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384439] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384518] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384679] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384758] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384876] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.384919] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385001] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385081] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385121] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385199] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385283] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385321] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385481] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385520] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385560] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385600] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385640] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385680] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385721] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385767] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385803] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.385886] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386043] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386123] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386202] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386283] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386362] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386442] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386522] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386603] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386682] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386762] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.386923] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387002] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387088] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387124] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387202] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387281] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387361] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387443] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387525] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387601] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387726] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387762] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387845] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387929] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.387963] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388042] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388122] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388203] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388282] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388362] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388522] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388595] xhci_hcd 0000:00:14.0: URB transfer length is wrong, xHC issue?
req. len = 4, act. len = 4294967292
[  860.388603] hub 3-7.1:1.0: hub_port_status failed (err = 0)
[  860.388642] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388721] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388801] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388886] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.388962] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389042] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389121] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389201] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389361] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389441] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389521] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389601] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389681] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389761] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389844] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389909] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.389943] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390021] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390181] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390261] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390341] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390421] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390501] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390581] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390661] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390742] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390821] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.390902] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391061] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391141] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391221] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391300] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391380] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391460] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391540] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391621] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391700] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391780] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.391940] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392020] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392100] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392180] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392260] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392340] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392420] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392500] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392580] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392662] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392820] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392901] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.392980] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393060] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393139] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393220] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393299] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393380] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393459] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393539] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393693] xhci_hcd 0000:00:14.0: URB transfer length is wrong, xHC issue?
req. len = 4, act. len = 4294967292
[  860.393701] hub 3-7.1:1.0: hub_port_status failed (err = 0)
[  860.393739] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393819] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393900] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.393979] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394059] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394139] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394223] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394259] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394339] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394502] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394539] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394619] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394698] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394785] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394836] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.394873] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.395196] usb 3-7.3: USB disconnect, device number 22
[  860.397907] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.397995] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398035] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398188] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398268] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398349] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398428] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398508] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398588] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398669] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398751] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398788] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398872] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.398990] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399068] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399148] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399228] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399308] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399388] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399468] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399550] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399629] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399707] hub 3-7.1:1.0: hub_port_status failed (err = -71)
[  860.399781] xhci_hcd 0000:00:14.0: URB transfer length is wrong, xHC issue?
req. len = 0, act. len = 4294967288
[  862.415413] usb 3-7: reset high-speed USB device number 20 using xhci_hcd
[  862.416046] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for
slot 29.
[  862.568894] usb 3-7: reset high-speed USB device number 20 using xhci_hcd
[  862.568984] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for
slot 29.
[  862.721812] usb 3-7: reset high-speed USB device number 20 using xhci_hcd
[  862.733416] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
disabled ep ffff88007b9e4ec0
[  863.029865] usb 3-7.1: reset high-speed USB device number 21 using xhci_hcd
[  863.029893] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for
slot 30.
[  863.104624] usb 3-7.1: reset high-speed USB device number 21 using xhci_hcd
[  863.104655] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for
slot 30.
[  863.179482] usb 3-7.1: reset high-speed USB device number 21 using xhci_hcd
[  863.190550] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
disabled ep ffff88007b9e4940
[  863.468430] usb 3-7.3: new high-speed USB device number 23 using xhci_hcd
[  863.561070] usb 3-7.3: New USB device found, idVendor=18d1, idProduct=4ee1
[  863.561080] usb 3-7.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  863.561086] usb 3-7.3: Product: Nexus 5
[  863.561090] usb 3-7.3: Manufacturer: LGE
[  863.561094] usb 3-7.3: SerialNumber: 07606f5400e1b31a
[  863.627036] usb 3-7.1.3: new low-speed USB device number 24 using xhci_hcd
[  863.708614] usb 3-7.1.3: New USB device found, idVendor=046d, idProduct=c326
[  863.708618] usb 3-7.1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  863.708620] usb 3-7.1.3: Product: USB Keyboard
[  863.708622] usb 3-7.1.3: Manufacturer: Logitech
[  863.709044] usb 3-7.1.3: ep 0x81 - rounding interval to 64 microframes, ep
desc says 80 microframes
[  863.709052] usb 3-7.1.3: ep 0x82 - rounding interval to 64 microframes, ep
desc says 80 microframes
[  863.715126] input: Logitech USB Keyboard as
/devices/pci0000:00/0000:00:14.0/usb3/3-7/3-7.1/3-7.1.3/3-7.1.3:1.0/0003:046D:C326.000E/input/input23
[  863.715693] hid-generic 0003:046D:C326.000E: input,hidraw0: USB HID v1.10
Keyboard [Logitech USB Keyboard] on usb-0000:00:14.0-7.1.3/input0
[  863.721843] input: Logitech USB Keyboard as
/devices/pci0000:00/0000:00:14.0/usb3/3-7/3-7.1/3-7.1.3/3-7.1.3:1.1/0003:046D:C326.000F/input/input24
[  863.722406] hid-generic 0003:046D:C326.000F: input,hiddev0,hidraw1: USB HID
v1.10 Device [Logitech USB Keyboard] on usb-0000:00:14.0-7.1.3/input1
[  863.783928] usb 3-7.1.4: new full-speed USB device number 25 using xhci_hcd
[  864.072776] usb 3-7.1.4: New USB device found, idVendor=0a12, idProduct=0001
[  864.072787] usb 3-7.1.4: New USB device strings: Mfr=0, Product=2,
SerialNumber=0
[  864.072792] usb 3-7.1.4: Product: BT2.0
[  864.141839] usb 3-7.1.6: new full-speed USB device number 26 using xhci_hcd
[  864.218945] usb 3-7.1.6: New USB device found, idVendor=046d, idProduct=c52b
[  864.218955] usb 3-7.1.6: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  864.218960] usb 3-7.1.6: Product: USB Receiver
[  864.218965] usb 3-7.1.6: Manufacturer: Logitech
[  864.232193] logitech-djreceiver 0003:046D:C52B.0012: hiddev0,hidraw2: USB
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-7.1.6/input2
[  864.291867] input: Logitech Unifying Device. Wireless PID:4026 as
/devices/pci0000:00/0000:00:14.0/usb3/3-7/3-7.1/3-7.1.6/3-7.1.6:1.2/0003:046D:C52B.0012/0003:046D:C52B.0013/input/input25
[  864.310086] logitech-djdevice 0003:046D:C52B.0013: input,hidraw3: USB HID
v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on
usb-0000:00:14.0-7.1.6:1
[  865.765895] usb 3-7.4: new high-speed USB device number 27 using xhci_hcd
[  865.852246] usb 3-7.4: New USB device found, idVendor=8564, idProduct=1000
[  865.852249] usb 3-7.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  865.852251] usb 3-7.4: Product: Mass Storage Device
[  865.852253] usb 3-7.4: Manufacturer: JetFlash
[  865.852254] usb 3-7.4: SerialNumber: 3988821812
[  865.853131] usb-storage 3-7.4:1.0: USB Mass Storage device detected
[  865.853702] scsi8 : usb-storage 3-7.4:1.0
[  866.855460] scsi 8:0:0:0: Direct-Access     JetFlash Transcend 32GB   1.00
PQ: 0 ANSI: 5
[  866.856300] sd 8:0:0:0: Attached scsi generic sg2 type 0
[  866.856316] sd 8:0:0:0: [sdc] 61741056 512-byte logical blocks: (31.6
GB/29.4 GiB)
[  866.856479] sd 8:0:0:0: [sdc] Write Protect is off
[  866.856481] sd 8:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  866.856630] sd 8:0:0:0: [sdc] Write cache: disabled, read cache: disabled,
doesn't support DPO or FUA
[  866.862959]  sdc: sdc1 sdc2 sdc3
[  866.865949] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[  867.162701] ISO 9660 Extensions: Microsoft Joliet Level 3
[  867.164229] ISO 9660 Extensions: RRIP_1991A
[  867.164254] SELinux: initialized (dev sdc1, type iso9660), uses
genfs_contexts

-- 
You are receiving this mail because:
You are the assignee for the bug.
