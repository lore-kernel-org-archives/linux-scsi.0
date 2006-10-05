From: ravianand <ravi.anand@qlogic.com>
Subject: Re: Symbol conflict in QLA drivers
Date: Thu, 5 Oct 2006 13:14:07 -0700
Message-ID: <20061005201407.GA7925@ranandlinuxbox.oc.cox.net>
References: <29174.1160055701@warthog.cambridge.redhat.com> <20061005142710.GA8141@ranandlinuxbox.qlogic.org> <1160064812.17994.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:62640 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751212AbWJEUOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 16:14:18 -0400
Content-Disposition: inline
In-Reply-To: <1160064812.17994.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Howells <dhowells@redhat.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

>On Thu, 05 Oct 2006, James Bottomley wrote:
> On Thu, 2006-10-05 at 07:27 -0700, ravianand wrote:
> > We will push a patch to fix it in qla4xxx driver.
> 
> Actually, if the symbol can't be made static, please fix both (say with
> a qla2/qla4 prefix or something) just so we don't get clashes with other
> areas of the kernel.
> 

Make sense. We will fix both.

Thanx
Ravi
