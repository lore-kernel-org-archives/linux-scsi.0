From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 06 Aug 2008 10:27:02 -0400
Message-ID: <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:49441 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYHFO2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 10:28:18 -0400
In-Reply-To: <Pine.LNX.4.64.0808061500450.1109@blonde.site> (Hugh Dickins's message of "Wed\, 6 Aug 2008 15\:06\:21 +0100 \(BST\)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:

Hugh> Commit e0597d70012c82e16ee152270a55d89d8bf66693 (sd: Identify
Hugh> DIF protection type and application tag ownership) says that if
Hugh> a disk is formatted with Inquiry bit PROTECT=1, it is required
Hugh> to support Read Capacity(16).  But my SD cards, accessed by
Hugh> builtin cardreader and generic USB storage, disagree.

Argh.  That's really broken.  USB storage has no business setting
PROTECT.

Can you send me the sg_inq output so I can see what else they are
returning?

-- 
Martin K. Petersen	Oracle Linux Engineering

