From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Tue, 6 Apr 2004 15:17:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406151713.A20117@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F281@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:41994 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263831AbUDFORP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 10:17:15 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F281@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Tue, Apr 06, 2004 at 10:03:58AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Apr 06, 2004 at 10:03:58AM -0400, Salyzyn, Mark wrote:
> OEMs and their users are virtually *all* we are concerned about. If we can not qualify our products within their needs, we disappear, or at least we disappear on operating systems that fail to provide for the needs of the users.

Well, bad luck for adaptec then.  It's not like there aren't other RAID HBA
vendors.

> I loose sleep at night thinking about these poor souls. No, to be honest, actually it is because our OEM's test group thinks out fantastic scenarios of ways to break yours and my products and hold us accountable for such failures. "Deleting array causes kernel ooops" news at 11 ...

Again, where do you see that oops?  if I remove the lun under a filesystem
that one spews EIO all over and becomes unusable.  But if you get a panic
that's a bug in the filesystem driver.

> Which reason do we ascribe to this failure of the operating system to provide the service of knowing if a drive is currently in-use:
> 
> 1) system has been architected in such a manner that it would be impossible at this juncture to add?
> 2) Someone made a conscientious decision to not provide this functionality?
> 3) There is a way to tell, it just is not clear to any of us at this moment?
> 4) There is a way to tell, but it would be an ugly hack that will no doubt break upon the next revision (as this hack has done traversing from 2.4 to 2.6)?
> 5) Pride?

There is a way to tell whether it's inuse, but it's a different defintion of
inuse than you want, and it's not a public interface so it could break all
the time.  Probably as soon as some out of tree driver gets the bright idea
to use it inspite everyone telling them not to.

