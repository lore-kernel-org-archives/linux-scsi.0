From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Subject: Mid-layer API?
Date: Wed, 18 Oct 2006 14:43:09 -0500
Message-ID: <861B5CF71BC70C478DFEB9EAFE98F699A86E82@G3W0068.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:26770 "EHLO
	ccerelbas01.cce.hp.com") by vger.kernel.org with ESMTP
	id S1422774AbWJRTnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2006 15:43:43 -0400
Received: from G3W0059.americas.hpqcorp.net (g3w0059.americas.hpqcorp.net [16.232.1.16])
	by ccerelbas01.cce.hp.com (Postfix) with ESMTP id 7AD7D347A3
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 14:43:40 -0500 (CDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

First, I'm a newbie to SCSI so please forgive me if any of the following
questions are silly. Having said that, I very much appreciate pointers
to good SCSI references and the Linux implementaion of the SCSI
subsystem...

I have a kernel driver that needs to send SCSI commands and data to a FC
disk attached to a Qlogic FC HBA. I'm hooking into the SCSI mid-layer by
calling scsi_do_req(). It seems to work but I'm not sure if this is the
right way of doing things. Is scsi_do_req the right entry point into the
mid-layer or should I use something else? Or should I hook into
something else than the mid-layer? And finally, is there any
documentation talking about the mid-layer API?

Any help is greatly appreciated.

Thanks
...juerg

