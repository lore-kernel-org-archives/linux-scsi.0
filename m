From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: proc_name in sysfs
Date: Mon, 11 Apr 2005 09:19:03 -0500
Message-ID: <1113229144.5827.4.camel@mulgrave>
References: <4253CA94.8000500@bull.net>
	 <20050408064645.GA4860@infradead.org> <42563AC4.4050605@torque.net>
	 <20050411115215.GB13154@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15585 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261800AbVDKOUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 10:20:06 -0400
In-Reply-To: <20050411115215.GB13154@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, Frederic TEMPORELLI <frederic.temporelli@bull.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-04-11 at 12:52 +0100, Christoph Hellwig wrote:
> James once had a proposal where the scsi_host can link to the module in
> sysfs, which is the right thing and needed for other things like mkinitrd
> aswell.

The code is actually in.  Taking advantage of it is slightly more
complex than I anticipated.  I'll dig out the patches I had for sym2 to
do it.

James


