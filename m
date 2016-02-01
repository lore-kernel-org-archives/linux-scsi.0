From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/12] be2iscsi: Remove unused mcc_cq_lock
Date: Mon, 01 Feb 2016 12:15:05 +0100
Message-ID: <1454325305.2442.2.camel@HansenPartnership.com>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
	 <1454321571-16167-2-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38662 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbcBALPJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 06:15:09 -0500
In-Reply-To: <1454321571-16167-2-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, 2016-02-01 at 15:42 +0530, Jitendra Bhivare wrote:
> mcc_cq_lock spin_lock is used only in beiscsi_process_mcc which is
> called
> only when all interrupts are disabled from mgmt_epfw_cleanup during
> unloading of driver. There is no other context where there can be
> contention for the processing of CQ.

Removing a lock is not a bug fix unless it's causing a user visible
problem, so this patch (and quite a lot of others in this series)
should go through the merge window process.

For things that cause user visible problems, we need a description of
the problem in the changelog and a cc to stable unless it was a
regression in the 4.4+ merge window.

Thanks,

James

