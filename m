From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Sun, 19 Oct 2014 04:07:59 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8921883@nice.asicdesigners.com>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
 <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
 <20141018151203.GA30355@infradead.org>,<20141018151843.GA4262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:19509
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750716AbaJSEJu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2014 00:09:50 -0400
In-Reply-To: <20141018151843.GA4262@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

Aah, thanks for the clarification. I have made mistakenly made this patch 
against drivers-for-3.18 then, but it applies cleanly to drivers-for-3.17 as 
well, please apply this to drivers-for-3.17.
-Anish
