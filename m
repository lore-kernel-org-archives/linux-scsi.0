From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid: fix null pointer check in megasas_detach_one().
Date: Thu, 04 Feb 2016 22:24:00 -0500
Message-ID: <yq1r3grg7qn.fsf@sermon.lab.mkp.net>
References: <1453466502-9335-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33573 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbcBEDYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 22:24:14 -0500
In-Reply-To: <1453466502-9335-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Fri, 22 Jan 2016 13:41:42 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: sumit.saxena@avagotech.com, kashyap.desai@avagotech.com, uday.lingala@avagotech.com, linux-scsi@vger.kernel.org, jbottomley@parallels.com, thenzl@redhat.com

>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:

Maurizio> The pd_seq_sync pointer can't be NULL, we have to check its
Maurizio> entries instead.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
