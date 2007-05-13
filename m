From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 11:18:35 -0500
Message-ID: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34222 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755771AbXEMQSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2007 12:18:44 -0400
In-Reply-To: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, 2007-05-13 at 11:10 -0500, James Bottomley wrote:
> > -	depends on SCSI
> > +	depends on SCSI_SCAN_ASYNC
> 
> No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
> wait scan to be built in, which isn't the idea at all.

Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
can alter this at boot time, so you could need the wait scan module even
with it set to N.

James


