From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/12] be2iscsi: Remove unused mcc_cq_lock
Date: Mon, 01 Feb 2016 20:44:31 -0500
Message-ID: <yq1powfophc.fsf@sermon.lab.mkp.net>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
	<1454321571-16167-2-git-send-email-jitendra.bhivare@avagotech.com>
	<1454325305.2442.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21773 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcBBBoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 20:44:44 -0500
In-Reply-To: <1454325305.2442.2.camel@HansenPartnership.com> (James
	Bottomley's message of "Mon, 01 Feb 2016 12:15:05 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> On Mon, 2016-02-01 at 15:42 +0530, Jitendra Bhivare wrote:
>> mcc_cq_lock spin_lock is used only in beiscsi_process_mcc which is
>> called only when all interrupts are disabled from mgmt_epfw_cleanup
>> during unloading of driver. There is no other context where there can
>> be contention for the processing of CQ.

James> Removing a lock is not a bug fix unless it's causing a user
James> visible problem, so this patch (and quite a lot of others in this
James> series) should go through the merge window process.

James> For things that cause user visible problems, we need a
James> description of the problem in the changelog and a cc to stable
James> unless it was a regression in the 4.4+ merge window.

I applied be2iscsi 11.0.0.0 to 4.6/scsi-queue about a week ago so this
is inevitably merge window material.

Jitendra, it's a good idea to spell out the intended target release or
repository when you post patches. Makes it easier for everyone.

Instead of "[PATCH 00/12] be2iscsi: critical fixes for 11.0.0.0" I would
suggest something like "[PATCH 00/12] be2iscsi: important fixes for
11.0.0.0 driver in 4.6/scsi-queue".

That way we know which tree to apply the patches to and it's clear that
it's an incremental update to a previously queued series.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
