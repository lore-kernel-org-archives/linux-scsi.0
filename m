From: Liran Schour <LIRANS@il.ibm.com>
Subject: Bidirectional support
Date: Tue, 18 Nov 2003 19:41:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFADB546DA.E3228E33-ONC2256DE2.005FDDD5-C2256DE2.0061252A@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:22180 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S263733AbTKRRnD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 12:43:03 -0500
Received: from d12relay02.megacenter.de.ibm.com (d12relay02.megacenter.de.ibm.com [9.149.165.196] (may be forged))
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id hAIHh1Bs041308
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2003 17:43:01 GMT
Received: from d10ml001.telaviv.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay02.megacenter.de.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hAIHgxN9275440
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2003 18:43:00 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Muli Ben-Yehuda <MULI@il.ibm.com>





The OSD standard requires support for bidirectional commands (write and get
obj attribute at the same command for example). The SAM-3 defines that in
order to execute a SCSI command the caller should supply an input an output
buffer. It seems that in the current Linux SCSI implementation the API
accept only one buffer, input our output buffer depends on the
data_direction flag.
Is there some work going on trying to implement bidirectional support?
Is it sound reasonable to extend the scatter-gather structure to include
data direction flag and by that bypass the interface problem and allow
support for bidirectional commands?

Thanks,
- Liran

