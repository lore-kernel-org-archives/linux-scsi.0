From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] give ->proc_info a struct Scsi_Host * parameter
Date: Tue, 13 May 2003 08:59:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513085942.A20372@lst.de>
References: <20030512160344.A11185@lst.de> <3EC09826.20406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:61445 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263228AbTEMGrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 02:47:08 -0400
Content-Disposition: inline
In-Reply-To: <3EC09826.20406@torque.net>; from dougg@torque.net on Tue, May 13, 2003 at 05:00:54PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, May 13, 2003 at 05:00:54PM +1000, Douglas Gilbert wrote:
> It is work in progress and I will send some patches
> and/or RFCs shortly. To do this I need access to
> scsi_host_hn_get() and scsi_host_put() so please leave
> them exported.

I disagree - these interfaces are problematic (and need a big revamp to
get working refcounting). But we can reconsider the export when you post your
patch.

