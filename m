From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/2] FC pass-through support for zfcp
Date: Mon, 06 Apr 2009 18:31:45 +0200
Message-ID: <20090406163145.686874000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48722 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZDFQfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 12:35:37 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id n36GZZEP002245
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 16:35:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n36GZZok3100708
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 18:35:35 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n36GZYJA026300
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 18:35:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sven Schuetz <sven@linux.vnet.ibm.com>, James.Smart@Emulex.Com

Here is the implementation of the FC pass-through support for zfcp.
The first patch is a fix required on top of the current linux-2.6
kernel and the second the actual implementation of the pass-through
support. This requires the FC pass-through patch from James Smart.

As soon as the common FC pass-through supports gets integrated, i
would like to add support for zfcp as well.

--
Christof Schmitt
