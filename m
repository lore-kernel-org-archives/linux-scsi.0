From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Mon, 03 Jan 2005 16:49:39 -0600
Message-ID: <1104792580.5506.69.camel@mulgrave>
References: <1104788704.5506.67.camel@mulgrave>
	 <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29341 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261901AbVACWuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 17:50:11 -0500
In-Reply-To: <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-03 at 22:43 +0000, Al Viro wrote:
> *UGH*
> 
> Why do you play with shoving dma_addr_t into a pair of pointers and
> then decoding it when you have ->SCp.dma_handle?

Well, I don't since it's not my driver.

However, I think the nutcase it's trying to crack is storing dma_addr_t
on x86 PAE.  There dma_addr_t is wider than a void *.

James


