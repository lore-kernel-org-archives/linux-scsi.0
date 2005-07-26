From: Russ Garrett <russ@garrett.co.uk>
Subject: Re: Megaraid problems with >8GB RAM
Date: Tue, 26 Jul 2005 23:35:24 +0100
Message-ID: <42E6BAAC.2070100@garrett.co.uk>
References: <42E6B2A5.9070903@garrett.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta08-winn.ispmail.ntl.com ([81.103.221.48]:47743 "EHLO
	mta08-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S262285AbVGZWfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 18:35:05 -0400
Received: from aamta09-winn.ispmail.ntl.com ([81.103.221.35])
          by mta08-winn.ispmail.ntl.com with ESMTP
          id <20050726223504.DFJU22560.mta08-winn.ispmail.ntl.com@aamta09-winn.ispmail.ntl.com>
          for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 23:35:04 +0100
Received: from [192.168.99.15] (really [82.18.123.115])
          by aamta09-winn.ispmail.ntl.com with ESMTP
          id <20050726223504.TKZK19483.aamta09-winn.ispmail.ntl.com@[192.168.99.15]>
          for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 23:35:04 +0100
In-Reply-To: <42E6B2A5.9070903@garrett.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Russ Garrett wrote:

> When installing Linux on a pair of new dual-opteron servers (16GB of 
> RAM and a MegaRAID 320-2), neither the megaraid v1, nor v2 drivers 
> could talk to the actual MegaRAID hardware. The v1 driver simply 
> caused the system to lock up, wheras the v2 driver produces the error 
> "megaraid: maibox adapter did not initialize" after a while.

Just to note that these cards are at the latest firmware (1L37), which 
is getting round to a year old now. I knew I'd forgotten to mention 
something.

Russ
