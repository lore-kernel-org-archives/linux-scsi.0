From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 17:16:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165B233.9080405@rtr.ca>
References: <4161A06D.8010601@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:60861 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S267904AbUJGVSX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 17:18:23 -0400
In-Reply-To: <4161A06D.8010601@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On a related note..

In the longer term, I'd like Jeff & I to get together and agree
upon some interface changes in libata to make it easier for this
driver (and others) to share more of the code dealing with
the emulation of non-data SCSI commands like INQUIRY and friends.

Right now that's not as easy as it could be, due to the specialized
libata struct parameters required, but I think it could be harmonized.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
