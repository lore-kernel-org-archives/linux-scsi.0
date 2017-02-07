From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sort out the ->eh_timed_out mess
Date: Mon, 06 Feb 2017 19:11:28 -0500
Message-ID: <yq1d1euuafj.fsf@oracle.com>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43323 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdBGALe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 19:11:34 -0500
In-Reply-To: <1485778739-29036-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Mon, 30 Jan 2017 13:18:55 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> We originally only supported the methods in the
Christoph> transport_template, which led to problems with drivers
Christoph> needing it and having to fake up a template.  Then we added
Christoph> it to the host to avoid that issue, but because the transport
Christoph> template takes precedence we still have various placed that
Christoph> need to hack around it.

Christoph> This series removes the transport_template instance and
Christoph> switches everyone to use the host method, similar to how we
Christoph> supply generic helpers elsewhere.

Christoph> In addition it removes a bit of cruft in the same area.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
