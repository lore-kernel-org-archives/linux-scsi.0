From: Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr) #2
Date: Tue, 27 Jan 2004 23:21:22 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040127122122.GS11236@krispykreme>
References: <4011969D.3070703@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:28630 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263486AbUA0MWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 07:22:04 -0500
Content-Disposition: inline
In-Reply-To: <4011969D.3070703@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


Hi Brian,

> Here is the latest version of the LLD for the IBM Power RAID family of
> adapters. This includes several IBM iSeries and pSeries SCSI adapters.
> Thanks to everyone who provided comments on the first round.

Great, I gave this a spin and noticed two trivial issues. Firstly it
wont compile with firmware load support not configured. Also
ipr_free_dump isnt wrapped in CONFIG_SCSI_IPR_DUMP.

Anton
