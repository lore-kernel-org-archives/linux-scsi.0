From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4.23
Date: 28 Dec 2003 14:45:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072644341.1784.17.camel@mulgrave>
References: <47F3C2BE74738E4683574107469DFA201EE1D8@XYUSEX01.xyus.xyratex.com>
	<20031228201020.C22668@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:34211 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262050AbTL1Upu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 15:45:50 -0500
In-Reply-To: <20031228201020.C22668@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Frank Borich <Frank_Borich@us.xyratex.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-12-28 at 14:10, Christoph Hellwig wrote:
> I'm not too happy about the form of this patch. Could you cook up one
> for 2.6.0 that adds a function pointer to poke at the inquiry data
> to the blacklist?  We could backport it to 2.4 later.

Actually, this can't really be done at all for 2.6 since we're extremely
careful not to get inquiry data beyond byte 56 and this patch is looking
into the vendor specific area at 96.

James


