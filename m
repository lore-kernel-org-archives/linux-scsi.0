From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH/RFT] check non-scsi part of status in scsi_status_is_good
Date: Thu, 30 Oct 2003 09:18:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031030091808.A6781@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org> <1067531731.4250.11.camel@pathost1.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:6533 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262679AbTJ3RUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 12:20:14 -0500
Content-Disposition: inline
In-Reply-To: <1067531731.4250.11.camel@pathost1.iomegacorp.com>; from p.lavarre@ieee.org on Thu, Oct 30, 2003 at 09:35:31AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On Thu, Oct 30, 2003 at 09:35:31AM -0700, Pat LaVarre wrote:

> Not idiosyncratic, if in fact -y "5A 00 08:00:00:00 00 00:1C 00" -i x1C
> does work.

OK, I finally get it after re-reading your other posts. 

Where the heck does that "-y / -i" syntax come from?

Per your other post, in short change to use MODE SENSE page 8 all the
time, even to get the write protect bit, and in addition use size 1c for
10 byte mode sense, and size 0x18 for the 6 byte variant.

If we had a full set of borken devices or testers, we could make the
change and know that it is well tested post 2.6.0.

-- Patrick Mansfield
