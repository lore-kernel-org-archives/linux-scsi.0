From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 06 Aug 2008 13:32:03 -0400
Message-ID: <yq17iauvylo.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	<yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	<Pine.LNX.4.64.0808061629220.10184@blonde.site>
	<1218040613.7493.13.camel@localhost.localdomain>
	<1218041582.7493.19.camel@localhost.localdomain>
	<Pine.LNX.4.64.0808061815360.27392@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:28529 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYHFRgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 13:36:17 -0400
In-Reply-To: <Pine.LNX.4.64.0808061815360.27392@blonde.site> (Hugh Dickins's message of "Wed\, 6 Aug 2008 18\:21\:18 +0100 \(BST\)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:

Hugh> Almost: I had to #include <scsi/scsi.h> to get SCSI_2 for the
Hugh> build somewhere (and a SCSI_2 seems to be worth 1 more than
Hugh> anyone else's 2), then it worked just fine for me thanks.

The DIF drives in question claim rev. 3 and are configured correctly
with James' patch in place.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
