From: "Lee Xing" <lxing@Crossroads.com>
Subject: A question on Linux SCSI low-level driver
Date: Fri, 7 May 2004 16:28:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFE3@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:60625 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S263800AbUEGV2V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 17:28:21 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

We are trying to write a low-level driver (no need for a perfect one at this time, just need to register the disks and do some simple I/Os).  I would sincerely appreciate it if some one could give me some information/suggestions/hints.

This low-level driver has indirect (via other layers) information on physical disks, so it can only provide mid-level driver with bus number, target number and lun number of the disks.  It will convert SCSI passthrough commands coming from the mid-level driver and send the converted command packages to the disks (again, via other layers).  It also sends the responses coming from physical disks (via other layers) back to the mid-level driver.  The "other layers" are SCSI-ready and can handle SCSI cmds/responses well.

My questions are: 

- is it (i.e. registering the disks with mid-level driver and doing some
  simple I/Os) doable if this low-level driver only provides mid-level with
  bus/target/lun numbers (without any hardware-related information)?
- what can be the potential problems (if nay)?

Best Regards,


Lee

