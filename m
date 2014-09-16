From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH 3] scsi: fix build errors, SCSI_FC_ATTRS needs to depend
 on SCSI && NET
Date: Tue, 16 Sep 2014 04:11:04 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88EBC4B@nice.asicdesigners.com>
References: <1410813921-24400-1-git-send-email-anish@chelsio.com>
 <1410813921-24400-2-git-send-email-anish@chelsio.com>,<5417825A.4050902@infradead.org>
 <525DB349B3FB5444AE057A887CB2A8D88EBB11@nice.asicdesigners.com>,<5417ABD7.3020005@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:10482
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750973AbaIPEMA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 00:12:00 -0400
In-Reply-To: <5417ABD7.3020005@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, David Miller <davem@davemloft.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mchan@broadcom.com" <mchan@broadcom.com>, "eddie.wai@broadcom.com" <eddie.wai@broadcom.com>, "jim.epost@gmail.com" <jim.epost@gmail.com>


________________________________________
From: Randy Dunlap [rdunlap@infradead.org]
Sent: Monday, September 15, 2014 8:17 PM
To: Anish Bhatt; netdev@vger.kernel.org; JBottomley@parallels.com; David Miller
Cc: linux-scsi@vger.kernel.org; mchan@broadcom.com; eddie.wai@broadcom.com; jim.epost@gmail.com
Subject: Re: [PATCH 3] scsi: fix build errors, SCSI_FC_ATTRS needs to depend on SCSI && NET

On 09/15/14 20:00, Anish Bhatt wrote:
>>
>> Doesn't fix make warnings, but SCSI_FC_ATTRS can no longer be selected without
>> NET. Though both ia64 and powerpc emit a lot of unmet dependency warnings as is
>> on defconfig


> You mean these kconfig warnings?
[....]
> I'll look into those.
>--
>~Randy

Yes, thanks
-Anish
