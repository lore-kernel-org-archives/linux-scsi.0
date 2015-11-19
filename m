From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/52] [resend] atp870u: Major rework
Date: Thu, 19 Nov 2015 12:10:23 -0500
Message-ID: <yq1oaepoqyo.fsf@sermon.lab.mkp.net>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37584 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbbKSRKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 12:10:33 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
	(Ondrej Zary's message of "Tue, 17 Nov 2015 19:23:36 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

>>>>> "Ondrej" == Ondrej Zary <linux@rainbow-software.org> writes:

Ondrej> This patch series removes the first level of crap from atp870u -
Ondrej> the worst (in-tree) SCSI driver [1] and then cleans up the code
Ondrej> a bit.

Ondrej> First the driver is converted to C from something that looks
Ondrej> like a (bad) assembler code: use of tmport for all I/O accesses
Ondrej> and gotos all over the code.  Then I/O access wrappers are
Ondrej> introduced.  Finally, is870, is880 and is885 are unified and two
Ondrej> of them removed.

Queued for 4.5.

-- 
Martin K. Petersen	Oracle Linux Engineering
