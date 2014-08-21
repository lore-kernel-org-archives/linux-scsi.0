From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature
 support
Date: Thu, 21 Aug 2014 21:49:52 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D85BA427@nice.asicdesigners.com>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com>
	<1407364668-20931-2-git-send-email-anish@chelsio.com>,<yq17g21qzus.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:16736
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754624AbaHUVvT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2014 17:51:19 -0400
In-Reply-To: <yq17g21qzus.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

Thanks for the heads up, will wait for those. Please cc me/Manoj on the patches
-Anish
________________________________________
From: Martin K. Petersen [martin.petersen@oracle.com]
Sent: Thursday, August 21, 2014 2:47 PM
To: Anish Bhatt
Cc: linux-scsi@vger.kernel.org; hch@infradead.org; jbottomley@parallels.com; michaelc@cs.wisc.edu; Karen Xie; Manoj Malviya
Subject: Re: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support

>>>>> "Anish" == Anish Bhatt <anish@chelsio.com> writes:

Anish,

Just a heads up that we've got some changes due to land shortly that'll
provide interfaces for you to get the correct transfer lengths, size of
the protection interval, etc. Your patch should be rebased on top of
those changes.

--
Martin K. Petersen      Oracle Linux Engineering
