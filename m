From: r35157anc3 <leo@leosandbox.org>
Subject: QLogic HBA and RFC2625
Date: Thu, 11 Dec 2003 14:29:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD8E1A9.4050007@leosandbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deagol.email.Arizona.EDU ([128.196.133.142]:40894 "EHLO
	smtpgate.email.arizona.edu") by vger.kernel.org with ESMTP
	id S263357AbTLKVWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 16:22:38 -0500
Received: from leosandbox.org (unknown [128.196.221.205])
	by smtpgate.email.arizona.edu (Postfix) with ESMTP id AD7C4237F6D
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2003 14:22:37 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Has anyone out there implemented the qla2xip drivers to use rfc2625? 
Just wondering how it all works? I read some of the rfc and the driver 
code. Does the qla2xip driver interface with the generic linux scsi 
driver or something? How does one mount over ip after configuring the 
hba for ip?

&Leo();
