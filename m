From: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Subject: 64-bit SCSI LUN addressing on Linux
Date: Thu, 30 Jun 2005 12:01:09 -0400
Message-ID: <42C41745.1020302@datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postoffice.datadirectnet.com ([64.213.193.141]:33965 "EHLO
	postoffice.datadirectnet.com") by vger.kernel.org with ESMTP
	id S262990AbVF3QBT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 12:01:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by postoffice.datadirectnet.com (Postfix) with ESMTP id 66DE5340717E
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2005 09:01:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Does Linux support 64-bit SCSI LUN addressing? Suppose I have a system 
that can create SCSI LUNs that are greater than 2TB using a block size 
of 512 bytes and can accept 16 byte CDBs, can I use this LUN with a 2.6 
series Linux kernel?

If so, are there any filesystems (ext3, XFS, etc. ) that can use a LUN > 
2TB?

Would I need any additional tools?

Would I need a 64-bit platform?
