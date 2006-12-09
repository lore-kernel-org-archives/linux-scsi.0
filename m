From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] imbvscsi: use 4k buffer  to transfer config data
Date: Fri, 8 Dec 2006 16:14:48 -0800
Message-ID: <20061208161448.75294251.randy.dunlap@oracle.com>
References: <457A24B9.2010804@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:29038 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947527AbWLIAOB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2006 19:14:01 -0500
In-Reply-To: <457A24B9.2010804@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lxiep@us.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, Dave C Boutcher <sleddog@us.ibm.com>, Santiago Leon <santil@us.ibm.com>

On Fri, 08 Dec 2006 20:51:37 -0600 Linda Xie wrote:

> Hi James,
> 
> This patch changes the size of the buffer used for transfering config 
> data to 4K. It was tested against
> 2.6.19-rc2 tree.
> 
> Please consider it for inclusion in upstream.

+/* host data buffer size */
+#define buff_size	4096

from Documentation/CodingStyle:

<quote>
Names of macros defining constants and labels in enums are capitalized.

#define CONSTANT 0x12345

Enums are preferred when defining several related constants.

CAPITALIZED macro names are appreciated but macros resembling functions
may be named in lower case.
</quote>

I conclude that it should be BUFF_SIZE.

---
~Randy
