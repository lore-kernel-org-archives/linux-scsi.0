From: "Zhao, Forrest" <forrest.zhao@intel.com>
Subject: One question about SCSI device hotplug
Date: Tue, 1 Mar 2005 17:06:55 +0800
Message-ID: <8126E4F969BA254AB43EA03C59F44E840184FB09@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from fmr19.intel.com ([134.134.136.18]:6067 "EHLO
	orsfmr004.jf.intel.com") by vger.kernel.org with ESMTP
	id S261836AbVCAJIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 04:08:22 -0500
Received: from orsfmr100.jf.intel.com (orsfmr100.jf.intel.com [10.7.209.16])
	by orsfmr004.jf.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j2198Lt4014774
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 09:08:21 GMT
Received: from pdsmsxvs01.pd.intel.com (pdsmsxvs01.pd.intel.com [172.16.12.122])
	by orsfmr100.jf.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with SMTP id j2198Ek1032039
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 09:08:21 GMT
Received: from pdsmsx331.ccr.corp.intel.com ([172.16.12.58])
 by pdsmsxvs01.pd.intel.com (SAVSMTP 3.1.7.47) with SMTP id M2005030117082004621
 for <linux-scsi@vger.kernel.org>; Tue, 01 Mar 2005 17:08:20 +0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Caushik, Ramesh" <ramesh.caushik@intel.com>

Hi, list

If I surprisingly hot-remove a SCSI disk from HBA manually 
without executing "echo "scsi remove-single-device
 <h> <b> <t <l>" > /proc/scsi/scsi", can the "hotplug"
event be notified to SCSI mid-layer or user space?

I briefly browse some code of LLDD, it seems that LLDD never
report "hotplug" event to upper-level layer. Am I right?


Thanks,
Forrest
