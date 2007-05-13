From: Dave Jones <davej@redhat.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 12:30:23 -0400
Message-ID: <20070513163023.GE27604@redhat.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com> <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbXEMQa0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 12:30:26 -0400
Content-Disposition: inline
In-Reply-To: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, May 13, 2007 at 11:18:35AM -0500, James Bottomley wrote:
 > On Sun, 2007-05-13 at 11:10 -0500, James Bottomley wrote:
 > > > -	depends on SCSI
 > > > +	depends on SCSI_SCAN_ASYNC
 > > 
 > > No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
 > > wait scan to be built in, which isn't the idea at all.
 > 
 > Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
 > can alter this at boot time, so you could need the wait scan module even
 > with it set to N.

Ah, good point.

	Dave

-- 
http://www.codemonkey.org.uk
