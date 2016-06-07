From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_debug: fix sleep in invalid context
Date: Mon, 06 Jun 2016 23:17:49 -0400
Message-ID: <yq14m95offm.fsf@sermon.lab.mkp.net>
References: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29618 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbcFGDS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2016 23:18:29 -0400
In-Reply-To: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
	(Douglas Gilbert's message of "Tue, 31 May 2016 17:15:07 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com, hch@infradead.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> In this post:
Doug> http://www.spinics.net/lists/linux-scsi/msg97124.html the author
Doug> shows some kernel infrastructure complaining about a sleep in an
Doug> invalid context. Remove offending call to vmalloc().  Instead of
Doug> using kzalloc() which reviewers didn't like, use a bucket system
Doug> (64 bytes on the stack) and potentially multiple calls to
Doug> sg_pcopy_from_buffer() to construct the 'data-in' buffer for the
Doug> SCSI REPORT LUNS command.

It would be great to get this reviewed...

-- 
Martin K. Petersen	Oracle Linux Engineering
