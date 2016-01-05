From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RFC 0/2] avoid crashing when reading /proc/scsi/scsi and simultaneously removing devices
Date: Mon, 04 Jan 2016 20:58:43 -0500
Message-ID: <yq1twmslrcc.fsf@sermon.lab.mkp.net>
References: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36525 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbcAEB6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2016 20:58:48 -0500
In-Reply-To: <1449583704-32400-1-git-send-email-emilne@redhat.com> (Ewan
	D. Milne's message of "Tue, 8 Dec 2015 09:08:22 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> The klist traversal used by the reading of /proc/scsi/scsi is not
Ewan> interlocked against device removal.  It takes a reference on the
Ewan> containing object, but this does not prevent the device from being
Ewan> removed from the list.  Thus, we get errors and eventually panic,
Ewan> as shown in the traces below.  Fix this by keeping a klist
Ewan> iterator in the seq_file private data.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
