From: Andrew Morton <akpm@osdl.org>
Subject: ibmvscsi on powerpc allmodconfig
Date: Sat, 5 Aug 2006 18:25:14 -0700
Message-ID: <20060805182514.94f43009.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38626 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751456AbWHFBbz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Aug 2006 21:31:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>

drivers/scsi/ibmvscsi/ibmvstgt.c: In function `ibmvstgt_rdma':
drivers/scsi/ibmvscsi/ibmvstgt.c:241: error: `H_Success' undeclared (first use in this function)
drivers/scsi/ibmvscsi/ibmvstgt.c:241: error: (Each undeclared identifier is reported only once
drivers/scsi/ibmvscsi/ibmvstgt.c:241: error: for each function it appears in.)
drivers/scsi/ibmvscsi/ibmvstgt.c: In function `send_adapter_info':
drivers/scsi/ibmvscsi/ibmvstgt.c:328: error: `H_Success' undeclared (first use in this function)

this has been happening for ages.
