From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 11:40:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF1852.6030306@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:45754 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265692AbUFOPkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:40:04 -0400
In-Reply-To: <1087313241.2710.40.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> to me it somewhat sounds like the wrong approach.
> I'm all for the LLDD to be able to influence the timeout value, but I
> consider it a bad mistake to make every driver reinvent timeout
> *handling*.

This has very little to do with the timeout _value_, and it has
all to do with *recovery* which is a beast on its own as far as transport
protocols are concerned, especially over non-native interconnects (iSCSI, USB,
RDMA). I believe I did mention this at the end of the text.
(mea culpa it was kind of a long text) 

-- 
Luben

