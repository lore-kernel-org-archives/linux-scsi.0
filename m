From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Tue, 31 Aug 2004 09:14:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413479D0.1060305@adaptec.com>
References: <0E3FA95632D6D047BA649F95DAB60E5704F631BD@exa-atlanta> <41347570.4020409@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:10728 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268458AbUHaNPB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 09:15:01 -0400
In-Reply-To: <41347570.4020409@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, Christoph Hellwig <hch@lst.de>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, linux-scsi@vger.kernel.org

Tuikov, Luben wrote:
> BTW, it is my conviction that _most_ (and maybe all) TMFs should
> be HOQ attribute tasks.  (This is one "feature" which would
> distinguish between different, say, iSCSI vendors, for example.
> "Did it hang?" "No, it recovered quickly.", etc.)

Heh, this is transport specific... I had too much iSCSI in my head...

But if the LLDD can send the TMF HOQ-like, e.g. "immediate" in iSCSI,
then this should be the case, IMO.  This we don't have to "recover" TMFs.

		Luben



