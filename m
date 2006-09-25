From: Israel Mouton <lebanon87@myrealbox.com>
Subject: Ultra320 drive detected as narrow SCSI by adapter
Date: Sun, 24 Sep 2006 17:20:17 -0700 (PDT)
Message-ID: <6478431.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:28838 "EHLO talk.nabble.com")
	by vger.kernel.org with ESMTP id S1751001AbWIYAUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 20:20:18 -0400
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1GReCn-00088j-Hi
	for linux-scsi@vger.kernel.org; Sun, 24 Sep 2006 17:20:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


While my adapter card is scanning for devices, it detects my Maxtor Atlas V
as a narrow drive; however, it is an Ultra320.  This setup was working fine
until a few days ago, when adapter began detecting it as a narrow SCSI.  Now
the disk can only transfer at about 10-20MB/s.  My adapter card is an LSI
53C1030 and is PCI-X.  If any one can help, I will be extremely grateful.
I also included my dmesg concerning SCSI devices output below.

mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=9
  Vendor: MAXTOR    Model: ATLAS10K5_147SCA  Rev: JNX0
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)
sda: Write Protect is off
sda: Mode Sense: bf 00 10 08
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)
sda: Write Protect is off
sda: Mode Sense: bf 00 10 08
SCSI device sda: drive cache: write back w/ FUA
 sda: sda1 sda2 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0

-- 
View this message in context: http://www.nabble.com/Ultra320-drive-detected-as-narrow-SCSI-by-adapter-tf2328646.html#a6478431
Sent from the linux-scsi mailing list archive at Nabble.com.

