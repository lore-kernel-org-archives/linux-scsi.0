From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 17 Aug 2004 12:07:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092766045.3266.2.camel@patlinux.iomegacorp.com>
References: <1091228652.6845.1.camel@patibmrh9><20040731141240.GE23697@suse.
	de><1092678938.4235.37.camel@patlinux.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:19683 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268369AbUHQSIh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 14:08:37 -0400
Received: from royntex01.iomegacorp.com (franklin [10.1.1.83])
	by email.iomega.com (Postfix) with ESMTP id 6B45A2004
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 12:08:36 -0600 (MDT)
In-Reply-To: <1092678938.4235.37.camel@patlinux.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> > And are you talking about the length of the cdb, or do you mean the
> > data that it can send/receive? I'd guess the latter,
> 
> Yes.
> 
> > but then cdb isn't the correct term.
> 
> Sorry I don't yet see why this thread doesn't fit into the category of
> arbitrary limits on bytes per CDB.

Kindly offline someone highlighted for me the ambiguity among the
arbitrary limits on the length of command, data, and status bytes
associated with a CDB.

Here I mean to be asking how to retune the arbitrary ide-cd limits on
the length of:

        data bytes/CDB of SCSI pass thru

Pat LaVarre


