From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context
Date: Wed, 1 Oct 2014 05:22:59 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88F76D1@nice.asicdesigners.com>
References: <1410828258-14692-1-git-send-email-anish@chelsio.com>,<20140922144547.GA32651@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:27943
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751187AbaJAFX0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 01:23:26 -0400
In-Reply-To: <20140922144547.GA32651@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

Little late, but I was hoping this would be pushed as part of fixes to 3.17. 
Is it too late for that ?
-Anish
________________________________________
From: Christoph Hellwig [hch@infradead.org]
Sent: Monday, September 22, 2014 7:45 AM
To: Anish Bhatt
Cc: linux-scsi@vger.kernel.org; JBottomley@parallels.com; Karen Xie; Manoj Malviya
Subject: Re: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context

Thanks,

applied.
