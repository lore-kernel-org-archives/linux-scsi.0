From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sat, 20 Aug 2005 00:57:38 -0400
Message-ID: <4306B842.6010708@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:5088 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750748AbVHTE55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Aug 2005 00:57:57 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
> For SAS, looking at Christoph's code - 
> The target id comes from the LLDD. So either the LLDD maintains a
> map of SAS port addresses to target ids, or the mapping could change,
> same as FC. Christoph's argument is that FC's issue was historical.


As James and I discussed on IRC, the FC mapping issue will crop up 
again, such as with SAS.

A core problem is that the SCSI layer expects to address things on a 
host/channel/id/lun basis, when _that_ addressing is largely a legacy 
holdover from parallel SCSI.

We need to figure out a way to move SCSI layer addressing forward, and 
eliminate any need for hacks such as FC's mapping.

FC's mapping hacks exist because the SCSI layer addressing needs to be 
made more flexible.

Unfortunately, as James also pointed out, changing addressing will cause 
lots of churn, and potentially some breakage.

	Jeff


