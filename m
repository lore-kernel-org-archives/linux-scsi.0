From: Douglas Gilbert <dgilbert@interlog.com>
Subject: T10 adds locally assigned UUID designation descriptor
Date: Mon, 8 Feb 2016 12:33:01 -0500
Message-ID: <56B8D14D.7020502@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60941 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbcBHRdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 12:33:08 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 3ED1220418F
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 18:33:05 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TMahS1ON-6LN for <linux-scsi@vger.kernel.org>;
	Mon,  8 Feb 2016 18:33:03 +0100 (CET)
Received: from [192.168.48.86] (host-45-58-206-50.dyn.295.ca [45.58.206.50])
	by smtp.infotech.no (Postfix) with ESMTPA id EB8FC2040AD
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 18:33:02 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Recently, in draft spc5r08, T10 added a locally assigned RFC 4122
UUID *** designation descriptor. That descriptor can now be
returned for VPD page 0x83 (device identification) amongst others.
It can be used anywhere SCSI needs a unique identifier expanding
the previous set of preferred identifiers: EUI, NAA and SCSI_name
(iSCSI).

In the soon to be released sg3_utils version 1.42 the new UUID
designation descriptor is decoded including Hannes' --export
option found in sg_inq, for example:

# sg_inq --export /dev/sg0
   ...
   SCSI_IDENT_LUN_UUID=11223344-5566-7788-aabb-ccddeeffffee

Perhaps some udev work is needed to incorporate this new identifier.

Doug Gilbert

** see  https://en.wikipedia.org/wiki/Universally_unique_identifier
