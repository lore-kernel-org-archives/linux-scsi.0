From: Mike Anderson <andmike@us.ibm.com>
Subject: Question on qla2xxx Kconfig update in 2.6.2
Date: Thu, 5 Feb 2004 08:37:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205163722.GA2498@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:54947 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S266362AbUBEQcl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 11:32:41 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>

Is the usage of SCSI_QLA2XXX_CONFIG instead of SCSI_QLA2XXX correct in
drivers/scsi/qla2xxx/Kconfig or have I just not had enough coffee this morning?

After a fresh bk pull and make config I could not get the qla2xxx
directory selected during a make modules. If I change to using SCSI_QLA2XXX in the Kconfig file everything is fine.

-andmike
--
Michael Anderson
andmike@us.ibm.com

