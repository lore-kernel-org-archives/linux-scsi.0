From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/3] Fix to cleanup aborted IO to avoid device being offlined by mid-layer
Date: Tue, 29 Mar 2016 20:46:52 -0400
Message-ID: <yq1bn5wssg3.fsf@sermon.lab.mkp.net>
References: <1458325370-25615-1-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23034 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbcC3Aq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 20:46:58 -0400
In-Reply-To: <1458325370-25615-1-git-send-email-satishkh@cisco.com> (Satish
	Kharat's message of "Fri, 18 Mar 2016 11:22:48 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>, Ewan Milne <emilne@redhat.com>

>>>>> "Satish" == Satish Kharat <satishkh@cisco.com> writes:

Satish,

Satish> If an I/O times out and an abort issued by host, if the abort is
Satish> successful we need to set scsi status as DID_ABORT. Or else the
Satish> mid-layer error handler which looks for this error code, will
Satish> offline the device. Also if the original I/O is not found in
Satish> fnic firmware, we will consider the abort as successful.  The
Satish> start_time assignment is moved because of the new goto.  Fnic
Satish> driver version changed from 1.6.0.17a to 1.6.0.19, version
Satish> 1.6.0.18 has been skipped

I applied patches 1-3 to 4.7/scsi-queue.

In the future, please make sure you add an "fnic:" prefix to the patch
description so it's clear in the commit log which driver is being
modified.

Also, always run checkpatch before submitting. I had to fix up a few
warnings.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
