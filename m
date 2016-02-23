From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] mptbase: fixup error handling paths in mpt_attach()
Date: Tue, 23 Feb 2016 17:47:15 -0500
Message-ID: <yq1mvqrjb7w.fsf@sermon.lab.mkp.net>
References: <1456236012-27300-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50618 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbcBWWr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 17:47:28 -0500
In-Reply-To: <1456236012-27300-1-git-send-email-emilne@redhat.com> (Ewan
	D. Milne's message of "Tue, 23 Feb 2016 09:00:12 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wuninsu@gmail.com, thenzl@redhat.com, sreekanth.reddy@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> mpt_attach() was not checking for the failure to create
Ewan> fw_event_q.  Also, iounmap() was not being called in all error
Ewan> cases after ioremap() had been called by mpt_mapresources().

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
