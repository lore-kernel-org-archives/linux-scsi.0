From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] RFC: libsas queuecommand fixups
Date: Mon, 11 Jul 2011 14:49:22 -0400
Message-ID: <20110711184922.859239377@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46856
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964828Ab1GKSuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 14:50:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

Fix up some lose ends in sas_queuecommand that I noticed during the isci
review.  The first two are pretty straight forward, but the third is a bit
more nasty and needs some serious review and testing.  Note that I could
only compile-test the bunch as I don't actually have a SAS controller
using libsas.
