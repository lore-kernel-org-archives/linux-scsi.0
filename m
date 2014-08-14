From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature
 support
Date: Thu, 14 Aug 2014 09:28:11 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D85A712A@nice.asicdesigners.com>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com>
 <1407364668-20931-2-git-send-email-anish@chelsio.com>,<53EC806C.20207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:17020
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbaHNJ3b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Aug 2014 05:29:31 -0400
In-Reply-To: <53EC806C.20207@dev.mellanox.co.il>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

We tested against a Sanblaze target. 
-Anish
________________________________________
From: Sagi Grimberg [sagig@dev.mellanox.co.il]
Sent: Thursday, August 14, 2014 2:25 AM
To: Anish Bhatt
Cc: linux-scsi@vger.kernel.org; hch@infradead.org; jbottomley@parallels.com; michaelc@cs.wisc.edu; Karen Xie; Manoj Malviya
Subject: Re: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support

On 8/7/2014 1:37 AM, Anish Bhatt wrote:
> Signed-off-by: Anish Bhatt <anish@chelsio.com>
> Signed-off by: Manoj Malvia <manojmalviya@chelsio.com>
> Signed-off by: Karen Xie <kxie@chelsio.com>
> ---
>   drivers/scsi/libiscsi.c     |  61 +++++++--
>   drivers/scsi/libiscsi_tcp.c | 296 ++++++++++++++++++++++++++++++++++++++++----
>   include/scsi/libiscsi.h     |   6 +
>   include/scsi/libiscsi_tcp.h |  22 ++++
>   4 files changed, 349 insertions(+), 36 deletions(-)
>

Hey Anish,

Against what target did you guys test this stuff?

Sagi.
