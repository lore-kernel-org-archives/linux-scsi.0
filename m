From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 16:54:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165ACF8.8060208@rtr.ca>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca> <416565DB.4050006@pobox.com> <4165A45D.2090200@rtr.ca> <4165A766.1040104@pobox.com> <4165A85D.7080704@rtr.ca> <4165AB1B.8000204@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:60093 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S268235AbUJGU4E
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 16:56:04 -0400
In-Reply-To: <4165AB1B.8000204@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lsml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

 >You're the only person in the world that
 >(a) needs these hooks NOW and (b) can utilize the hooks NOW,
 >by your own admission  ;-)

Actually, no.

There's a full-time programmer at PDC working
on the RAID management layer for this, plus all
of the folks there working on the O/S independent
apps in userland for the card.

Perhaps I can get hold of an early snapshot of that
code from them (the chardev driver), and submit that
as a subsequent patch.

So, skipping the EXPORTs for now, how do you guys
feel about the driver ?

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
