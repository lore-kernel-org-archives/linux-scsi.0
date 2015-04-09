From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 15/21] lpfc: Implement support for wire-only DIF devices
Date: Thu, 09 Apr 2015 17:20:09 -0400
Message-ID: <yq1lhi1f186.fsf@sermon.lab.mkp.net>
References: <1428095580.6933.44.camel@myfc17>
	<20150405160613.GA8622@infradead.org> <5526E80C.5090807@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37287 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbDIVUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 17:20:41 -0400
In-Reply-To: <5526E80C.5090807@emulex.com> (James Smart's message of "Thu, 9
	Apr 2015 16:58:52 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "James" == James Smart <james.smart@emulex.com> writes:

James> fyi - in the v3 of the lpfc 10.5.0.0 patches I just posted, I
James> pulled the patch.  We will see what to do with it. We may come
James> back with a set of generic midlayer patches.

We already have a DIF blacklist. We could have an explicit whitelist as
well. But it begs the question: Why on earth are 3Par not following the
spec? And why don't they just fix their firmware to report the right
thing?

-- 
Martin K. Petersen	Oracle Linux Engineering
