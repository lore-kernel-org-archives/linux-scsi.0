From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] hpsa: correct abort tmf for hba devices
Date: Tue, 23 Feb 2016 17:22:29 -0600
Message-ID: <B3019C66-E4D0-4726-A673-EC2477B08538@linux.vnet.ibm.com>
References: <20160223210957.5968.6998.stgit@brunhilda> <20160223211628.5968.7606.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:43419 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbcBWXWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 18:22:33 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 23 Feb 2016 18:22:33 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 6AF2C6E8041
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2016 18:09:23 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1NNMVVV31391880
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2016 23:22:31 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1NNMUmC025898
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2016 18:22:31 -0500
In-Reply-To: <20160223211628.5968.7606.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, Christoph Hellwig <hch@infradead.org>, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi <linux-scsi@vger.kernel.org>

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

