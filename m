From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: Avoid crashing if device uses DIX but adapter does not support it
Date: Mon, 19 Jan 2015 20:48:45 -0500
Message-ID: <yq14mrmql1e.fsf@sermon.lab.mkp.net>
References: <1421334132-31491-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22364 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbATBsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 20:48:51 -0500
In-Reply-To: <1421334132-31491-1-git-send-email-emilne@redhat.com> (Ewan
	D. Milne's message of "Thu, 15 Jan 2015 10:02:12 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> This can happen if a multipathed device uses DIX and another path
Ewan> is added via an adapter that does not support it.  Multipath
Ewan> should not allow this path to be added, but we should not depend
Ewan> upon that to avoid crashing.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
