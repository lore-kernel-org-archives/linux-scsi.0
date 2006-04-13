From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: HBA self selection
Date: Thu, 13 Apr 2006 13:35:42 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044BFE@cceexc17.americas.cpqcorp.net>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net> <443E9141.6030901@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:20704 "EHLO
	ccerelbas03.cce.hp.com") by vger.kernel.org with ESMTP
	id S932361AbWDMShv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2006 14:37:51 -0400
Received: from cceexg13.americas.cpqcorp.net (cceexg13.americas.cpqcorp.net [16.81.1.58])
	by ccerelbas03.cce.hp.com (Postfix) with ESMTP id 4A32334276
	for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2006 13:37:51 -0500 (CDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org


I didn't try it yet, but a cursory look through the code
makes me think it winds up in the same place, __scan_scsi_target,
so I think it probably won't work any differently.  Thanks
for the idea though (and for reminding me of the new way.  Old
habits die hard.)

-- steve

-----Original Message-----
From: Douglas Gilbert [mailto:dougg@torque.net]
[...]
Steve,
I suppose the lk 2.6 equivalent of:
# echo "0 7 0" > /sys/class/scsi_host/host<n>/scan
doesn't work either? [The reason I ask is that the
new technique works for finding "well known" lus.]

Doug Gilbert


