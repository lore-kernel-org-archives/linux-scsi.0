From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: silent -Wformat-security warning
Date: Thu, 05 Jan 2017 20:51:26 -0500
Message-ID: <yq1fukxhs69.fsf@oracle.com>
References: <20161226132310.3204-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48769 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753392AbdAFBvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:51:37 -0500
In-Reply-To: <20161226132310.3204-1-nicolas.iooss_linux@m4x.org> (Nicolas
        Iooss's message of "Mon, 26 Dec 2016 14:23:09 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Madhani <himanshu.madhani@qlogic.com>

>>>>> "Nicolas" == Nicolas Iooss <nicolas.iooss_linux@m4x.org> writes:

Nicolas> qla24xx_enable_msix() calls scnprintf() with a non-literal
Nicolas> format string. This makes clang report -Wformat-security
Nicolas> warnings when compiling this function:

Himanshu: Please review these two patches!

-- 
Martin K. Petersen	Oracle Linux Engineering
