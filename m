From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] hpsa: check for a null phys_disk pointer in ioaccel2 path
Date: Tue, 23 Feb 2016 17:22:59 -0600
Message-ID: <A1A44659-5D47-4339-BC2A-D729CF4D1F7F@linux.vnet.ibm.com>
References: <20160223210957.5968.6998.stgit@brunhilda> <20160223211634.5968.96070.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:54996 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbcBWXXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 18:23:07 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 23 Feb 2016 18:23:06 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 23920C90041
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2016 18:23:01 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1NNN3Ld26411116
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2016 23:23:03 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1NNN1mo028273
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2016 18:23:03 -0500
In-Reply-To: <20160223211634.5968.96070.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, Christoph Hellwig <hch@infradead.org>, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi <linux-scsi@vger.kernel.org>

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

