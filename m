From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
Date: Tue, 07 Apr 2015 19:14:35 -0400
Message-ID: <yq11tjvil9g.fsf@sermon.lab.mkp.net>
References: <201503271156.t2RBum1Y032249@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21193 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbbDGXPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 19:15:24 -0400
In-Reply-To: <201503271156.t2RBum1Y032249@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Fri, 27 Mar 2015 17:25:17 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> This patch has code optimization and refactoring in below areas-
Sumit> 1) Created separate functions for sysPD IOs and non Read Write
Sumit> LDIOs.  2) Added function for refiring MFI commands in controller
Sumit> reset path.  3) Enabling interrupt immediately after adapter's
Sumit> initialization.  4) Added function for setting up IRQs.  5)
Sumit> Modified few prints for better logging.  6) Modified few macros
Sumit> not to pass unused parameters.  7) Move internal commands and
Sumit> SCSI commands reservation in adapter's sepcific functions.

This needs to be 7 patches and not 1.

-- 
Martin K. Petersen	Oracle Linux Engineering
