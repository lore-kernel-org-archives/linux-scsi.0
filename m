From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Sat, 15 Sep 2007 09:12:56 -0500
Message-ID: <1189865576.3339.0.camel@localhost.localdomain>
References: <20070721203410.GA1004@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42891 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751525AbXIOOM7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 10:12:59 -0400
In-Reply-To: <20070721203410.GA1004@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Sat, 2007-07-21 at 16:34 -0400, Jeff Garzik wrote:
> This is the rest of the stuff checked into the 'gdth' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> 
> As noted before, I'm fine with Christoph's gdth work superceding mine,
> or whatever.  This was just me poking around.  Hopefully the patches
> are useful for illustration, if nothing else.
> 
> 1) [SCSI] gdth: kill gdth_{read,write}[bwl] wrappers
> 2) [SCSI] gdth: Move probe-time error handling code to end of each function
> 3) [SCSI] gdth: make some virt ctrlr code common; shuffle SHT members
> 4) [SCSI] gdth: convert to modern SCSI host alloc/scan

OK, we've had these competing patch sets floating around for two months
now.  Christoph and Jeff, can we get agreement on which is going in?

James


