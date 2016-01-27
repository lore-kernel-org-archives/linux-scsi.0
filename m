From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/17] be2iscsi: driver update 11.0.0.0
Date: Tue, 26 Jan 2016 20:45:16 -0500
Message-ID: <yq1wpqviymr.fsf@sermon.lab.mkp.net>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43459 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbcA0Bp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 20:45:26 -0500
In-Reply-To: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
	(Jitendra Bhivare's message of "Wed, 20 Jan 2016 14:10:44 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

>>>>> "Jitendra" == Jitendra Bhivare <jitendra.bhivare@avagotech.com> writes:

Applied to 4.6/scsi-queue.

PATCH 12/17: "be2iscsi: Fix IOPOLL implementation" conflicted with
Christoph's irq_poll changes. I fixed it up but please verify:

http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.6/scsi-queue&id=fa512e1a3156

-- 
Martin K. Petersen	Oracle Linux Engineering
