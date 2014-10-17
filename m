From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Fri, 17 Oct 2014 19:43:34 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:11102
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753313AbaJQTp1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2014 15:45:27 -0400
In-Reply-To: <1413500359-27521-1-git-send-email-anish@chelsio.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

I actually wanted to get some clarification on how the branches on scsi-queue
 work. The core/drivers separation is easy enough, but the current branches 
are confusing. If say I am submitting a bug fix for the next 3.17 release, what
 branch should I be basing my changes on ? Is there a preferred procedure for
 submitting bug fixes vs new features ?
-Anish