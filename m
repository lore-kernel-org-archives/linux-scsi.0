From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [SCSI] ibmvscsi: Fix SCSI scanning
Date: Mon, 20 Jun 2011 07:40:58 -0400
Message-ID: <20110620114058.GA7372@infradead.org>
References: <201106191348.40759.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46904
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875Ab1FTLlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 07:41:02 -0400
Content-Disposition: inline
In-Reply-To: <201106191348.40759.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Sun, Jun 19, 2011 at 01:48:40PM +0200, Bart Van Assche wrote:
> Avoid that SCSI scanning triggers creation of targets with a non-zero
> channel number.

Same comment as for the SRP one applies here as well.

