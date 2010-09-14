From: Lee Jones <lee.jones@canonical.com>
Subject: Blank DVD is not detected / cannot burn
Date: Tue, 14 Sep 2010 12:27:58 +0100
Message-ID: <4C8F5C3E.80909@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:34503 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0INL17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 07:27:59 -0400
Received: from hutte.canonical.com ([91.189.90.181])
	by adelie.canonical.com with esmtp (Exim 4.69 #1 (Debian))
	id 1OvTg6-0004Xt-3g
	for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2010 12:27:58 +0100
Received: from cpc2-aztw21-0-0-cust264.aztw.cable.virginmedia.com ([77.100.97.9] helo=[192.168.0.2])
	by hutte.canonical.com with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <lee.jones@canonical.com>)
	id 1OvTg5-0004oa-V4
	for linux-scsi@vger.kernel.org; Tue, 14 Sep 2010 12:27:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A bug as been reported me to where some DVD-RW drives are unable to detect blank DVDs. Apparently this is a regression issue, as the reporting user is insisting that they used to be able to burn DVDs using the same hardware.

The reporting user provided this dmesg output. I believe they tried a few different disks to gain this response.

I am pasting dmesg output from these attempts:
[ 3563.989601] sr 5:0:1:0: [sr0] Unhandled sense code
[ 3563.989606] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3563.989609] sr 5:0:1:0: [sr0] Sense Key : Medium Error [current]
[ 3563.989614] sr 5:0:1:0: [sr0] ASC=0x10 <<vendor>> ASCQ=0x90
[ 3563.989621] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 05 6f 60 00 00 02 00
[ 3563.989629] end_request: I/O error, dev sr0, sector 1424768
[ 3563.989633] quiet_error: 3 callbacks suppressed
[ 3563.989636] Buffer I/O error on device sr0, logical block 178096
[ 3607.084661] sr 5:0:1:0: [sr0] Device not ready
[ 3607.084665] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.084669] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.084673] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.084677] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.084685] end_request: I/O error, dev sr0, sector 120
[ 3607.084690] Buffer I/O error on device sr0, logical block 15
[ 3607.090021] sr 5:0:1:0: [sr0] Device not ready
[ 3607.090023] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.090026] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.090029] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.090032] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.090039] end_request: I/O error, dev sr0, sector 120
[ 3607.090042] Buffer I/O error on device sr0, logical block 15
[ 3607.095382] sr 5:0:1:0: [sr0] Device not ready
[ 3607.095384] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.095387] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.095390] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.095393] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.095400] end_request: I/O error, dev sr0, sector 120
[ 3607.095403] Buffer I/O error on device sr0, logical block 15
[ 3607.099609] sr 5:0:1:0: [sr0] Device not ready
[ 3607.099613] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.099617] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.099620] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.099624] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.099632] end_request: I/O error, dev sr0, sector 120
[ 3607.099636] Buffer I/O error on device sr0, logical block 15
[ 3607.104870] sr 5:0:1:0: [sr0] Device not ready
[ 3607.104872] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.104875] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.104878] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.104882] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.104889] end_request: I/O error, dev sr0, sector 120
[ 3607.104892] Buffer I/O error on device sr0, logical block 15
[ 3607.111000] sr 5:0:1:0: [sr0] Device not ready
[ 3607.111006] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.111010] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.111014] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.111021] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.111028] end_request: I/O error, dev sr0, sector 120
[ 3607.111033] Buffer I/O error on device sr0, logical block 15
[ 3607.116389] sr 5:0:1:0: [sr0] Device not ready
[ 3607.116391] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3607.116394] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
[ 3607.116398] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
[ 3607.116401] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
[ 3607.116408] end_request: I/O error, dev sr0, sector 120
[ 3607.116410] Buffer I/O error on device sr0, logical block 15
[ 3635.494275] sr 5:0:1:0: [sr0] Unhandled sense code
[ 3635.494279] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3635.494283] sr 5:0:1:0: [sr0] Sense Key : Medium Error [current]
[ 3635.494287] sr 5:0:1:0: [sr0] ASC=0x10 <<vendor>> ASCQ=0x90
[ 3635.494293] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 05 6f 60 00 00 02 00
[ 3635.494301] end_request: I/O error, dev sr0, sector 1424768
[ 3635.494307] Buffer I/O error on device sr0, logical block 178096
[ 3647.817487] ISO 9660 Extensions: Microsoft Joliet Level 3
[ 3648.020437] ISO 9660 Extensions: RRIP_1991A
[ 3791.322659] cdrom: This disc doesn't have any tracks I recognize!

The same user later reported the following log messages:

[ 3912.648032] Clocksource tsc unstable (delta = -231260494 ns)
[ 4306.359731] cdrom: This disc doesn't have any tracks I recognize!

Two of the users were kind enough to provide qpxtool print screens:
http://launchpadlibrarian.net/54734405/qpxtool-drive.jpg
http://launchpadlibrarian.net/54788615/qpxtool-screenshot.png

Any help, or pointers in the right direction would be appreciated.

Kind regards,
Lee
