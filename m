From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Sat, 12 Sep 2009 01:06:11 +0200
Message-ID: <4AAAD7E3.6010209@interlog.com>
References: <1252696852-17091-1-git-send-email-martin.petersen@oracle.com> <1252696852-17091-6-git-send-email-martin.petersen@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38074 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZIKXGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:06:11 -0400
In-Reply-To: <1252696852-17091-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> Add support for 32-byte READ/WRITE as well as DIF Type 2 protection.
> 
> Reject protected 10/12/16 byte READ/WRITE commands when Type 2 is
> enabled.
> 
> Verify Type 2 reference tag according to Expected Initial LBA in 32-byte
> CDB.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
