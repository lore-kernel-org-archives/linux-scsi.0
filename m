From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr) #2
Date: Tue, 27 Jan 2004 09:06:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40167E82.7040508@us.ibm.com>
References: <4011969D.3070703@us.ibm.com> <20040127122122.GS11236@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:18168 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264245AbUA0PGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 10:06:45 -0500
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

Anton Blanchard wrote:
> Hi Brian,
> 
> 
>>Here is the latest version of the LLD for the IBM Power RAID family of
>>adapters. This includes several IBM iSeries and pSeries SCSI adapters.
>>Thanks to everyone who provided comments on the first round.
> 
> 
> Great, I gave this a spin and noticed two trivial issues. Firstly it
> wont compile with firmware load support not configured. Also
> ipr_free_dump isnt wrapped in CONFIG_SCSI_IPR_DUMP.

Thanks. To solve the first problem, I'll just add an "enable FW_LOADER" in
Kconfig.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

