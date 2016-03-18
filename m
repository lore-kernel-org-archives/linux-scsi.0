From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fnic: move printk()s outside of the critical code section.
Date: Fri, 18 Mar 2016 15:28:51 -0400
Message-ID: <yq1vb4j8u18.fsf@sermon.lab.mkp.net>
References: <1458135848-7770-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbcCRT27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2016 15:28:59 -0400
In-Reply-To: <1458135848-7770-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Wed, 16 Mar 2016 14:44:08 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, hiralpat@cisco.com, sramars@cisco.com, buchino@cisco.com, jejb@linux.vnet.ibm.com

>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:

Maurizio> This patch moves a printk() outside of the code section where
Maurizio> interrupt are disabled. In some cases a flood of error
Maurizio> messages may cause a kernel panic.  It also removes one of the
Maurizio> printk()s because the same error message was printed twice.

Applied to 4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
