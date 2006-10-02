From: getitright <bret_stern@machinemanagement.com>
Subject: SCSI basics - dell 210s
Date: Sun, 1 Oct 2006 18:01:50 -0700 (PDT)
Message-ID: <6594636.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:39091 "EHLO talk.nabble.com")
	by vger.kernel.org with ESMTP id S932545AbWJBBBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Oct 2006 21:01:51 -0400
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1GUCBq-0001G4-Qi
	for linux-scsi@vger.kernel.org; Sun, 01 Oct 2006 18:01:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


good day,

I have a Dell 2450 with two 18gb drives, connected to the
internal scsi adapter. Fine.
They are /dev/sda  and  /dev/sdb.

Now i have added an additional pci Adaptec 2940 scsi adapter
connected to a Dell 210s with seven 9gb drives.

The above two drives (which were in the Dell 2450) are
now:  /dev/sdh.../dev/sdi.
Why did they change order/id?
Does the external adapter (2940) precede the scsi
id's of the internal scsi adapter?

Does scsi order the scsi id of ALL the combined scsi
devices?

Is there a way to keep the 2450 internal drives
as /dev/sda, and /dev/sdb?
Would i want ot keep them any specific way?

Any suggestions for a good scsi arrangement with this
Dell 2450 and Powervault 210s configuration (besides raid,
i don't have the perc controller yet).

Lot's of questions, but I know there is some good advice
out there.

So many thanks for comments.

Bret

-- 
View this message in context: http://www.nabble.com/SCSI-basics---dell-210s-tf2367210.html#a6594636
Sent from the linux-scsi mailing list archive at Nabble.com.

