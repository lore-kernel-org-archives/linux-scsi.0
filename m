From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.5] ips: remove arch limitations
Date: Thu, 28 Aug 2003 12:08:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F4E28E8.0@pobox.com>
References: <1062086838.25316.32.camel@blackmagic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16805 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264087AbTH1QIT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 12:08:19 -0400
In-Reply-To: <1062086838.25316.32.camel@blackmagic>
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <david_jeffery@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

David Jeffery wrote:
> This patch removes the X86 arch limitation in drivers/scsi/Kconfig,
> downgrades the #error check for x86/x86_64/ia64 to a #warning, and
> updates an old email address in the help.
> 
> It also fixes up a two places in the driver which have 8 spaces instead
> of a tab for indention.


Looks good, thanks!

	Jeff



