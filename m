From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID v.96 for 2.6.9-rc2
Date: Tue, 21 Sep 2004 13:58:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41506BBE.2050507@rtr.ca>
References: <4150666A.90807@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:2723 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S267916AbUIUSAG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 14:00:06 -0400
In-Reply-To: <4150666A.90807@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Okay, I missed one thing in the proof read.. these two lines (below)
will be added to qstor.c, for use by the separate RAID management module.

    EXPORT_SYMBOL(qs_del_raid);
    EXPORT_SYMBOL(qs_setup_raid);

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
