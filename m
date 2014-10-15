From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH] cxgb4i : fix rtnl lock assertion
Date: Wed, 15 Oct 2014 07:40:07 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D891BE05@nice.asicdesigners.com>
References: <1412283574-23119-1-git-send-email-anish@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:17768
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238AbaJOHlU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2014 03:41:20 -0400
In-Reply-To: <1412283574-23119-1-git-send-email-anish@chelsio.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

Please do not apply this patch. This got fixed in the net tree as part of a 
larger changeset, at the following commit :
587ddfe2d212 (cxgb4i : Remove duplicated CLIP handling code)
-Anish