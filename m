From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] Move helper code from FC drivers to FC transport
Date: Fri, 30 Oct 2009 17:59:28 +0100
Message-ID: <20091030165928.517760000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:42659 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbZJ3RHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 13:07:23 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.1/8.13.1) with ESMTP id n9UH7SAu001636
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2009 17:07:28 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9UH7RFX692444
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2009 18:07:27 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9UH7RNN020054
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2009 18:07:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

This patch moves duplicated code from three FC drivers to the SCSI FC
transport class. I am working on a follow-on patch for zfcp to apply
the same strategy of holding off SCSI recovery while the remote ports
are blocked. 

The patch applies cleanly to the current scsi-misc tree. I could only
make sure that it compiles on x86, but the code move is fairly
trivial.

--
Christof Schmitt
