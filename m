From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sense handling improvements
Date: Wed, 15 Feb 2017 22:42:56 -0500
Message-ID: <yq18tp6by2n.fsf@oracle.com>
References: <20170214191600.17480-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40085 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdBPDnG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 22:43:06 -0500
In-Reply-To: <20170214191600.17480-1-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 14 Feb 2017 20:15:54 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernek.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> this series is on top of the scsi_request changes in Jens'
Christoph> tree and further improves the handling of the sense buffer.

Very nice cleanup!

Christoph> The first patch prevents any possibily of reusing stale sense
Christoph> codes in sense headers, and is a bug fix that we should
Christoph> probably get into the block tree ASAP.

Christoph> The rest cleans up handling of the parsed sense data and
Christoph> could go in either through the block tree, or a SCSI branch
Christoph> on top of the block tree.

I can bring them in after Linus' initial block pull.

-- 
Martin K. Petersen	Oracle Linux Engineering
