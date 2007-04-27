From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Fri, 27 Apr 2007 18:56:56 -0500 (CDT)
Message-ID: <20070427235656.B767BDBA2@gherkin.frus.com>
References: <20070427231346.647797bc@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:50557 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbXD0X45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 19:56:57 -0400
In-Reply-To: <20070427231346.647797bc@the-village.bc.nu> "from Alan Cox at Apr
 27, 2007 11:13:46 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Cox wrote:
> > As before, no problems using the sda hard disk (which is the boot drive):
> > everything works reliably until I touch the cdrom drive.
> 
> A little quiet contemplation and gnome number 387 suggests trying the following
> (and providing more detailed information such as the last message printed before
> the DMA message). Stuff a BUG() before the panic in BAD_DMA (aha1542.c) if needed
> to get a good trace.
> 
> Please report success/failure/change.

Can do.  I don't have access to the machine on weekends, so it will be
at least Monday before I can give this a whirl.  Thanks!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
