From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 19:49:52 -0600
Message-ID: <1108518592.5539.88.camel@mulgrave>
References: <7526e305050215152950f5a69e@mail.gmail.com>
	 <1108513997.5539.76.camel@mulgrave>
	 <7526e305050215165450200ce2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:51431 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261873AbVBPBt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 20:49:56 -0500
In-Reply-To: <7526e305050215165450200ce2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Scsi <joe.scsi@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-02-15 at 16:54 -0800, Joe Scsi wrote:
> OK (and sorry if I'm being dense) but does this mean that a network
> SCSI transport should make up an "id" for each target port it connects
> to and then call scsi_scan_target()?

Currently yes ... now that we allow unscanned hosts, it's not strictly
necessary; we could allow the target id to be a string with meaning to
the driver, but that's for another day.

James


