From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sim710_device_remove seems buggy
Date: Tue, 17 Jul 2007 13:57:48 -0500
Message-ID: <1184698668.3378.17.camel@localhost.localdomain>
References: <20070717165521.GE14791@parisc-linux.org>
	 <20070717185216.GF14791@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41427 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759145AbXGQS5t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 14:57:49 -0400
In-Reply-To: <20070717185216.GF14791@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org

On Tue, 2007-07-17 at 12:52 -0600, Matthew Wilcox wrote:
> On Tue, Jul 17, 2007 at 10:55:21AM -0600, Matthew Wilcox wrote:
> > Unfortunately, I don't have a good idea about how to solve this.  The
> > least lame perhaps is to have separate routines for EISA and MCA
> > devices, each of which passes the shost to this routine.
> 
> I had an idea.  How does this look?  It's what I'm doing in advansys.
> Note that I've not tested it more than compilation ... need to get the
> EISA configurator running on parisc-linux in order to test it.

That's certainly the way lasi700 does it ... so it makes sense that this
driver should as well.

James


