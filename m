From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [Bugme-new] [Bug 38312] New: Oops in kmem_cache_alloc
Date: Mon, 27 Jun 2011 23:04:43 +0200
Message-ID: <20110627210443.GB18664@uio.no>
References: <bug-38312-10286@https.bugzilla.kernel.org/>
 <20110627133007.f6cba848.akpm@linux-foundation.org>
 <1309207300.2605.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:54988 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1F0VcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 17:32:19 -0400
Content-Disposition: inline
In-Reply-To: <1309207300.2605.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 27, 2011 at 03:41:40PM -0500, James Bottomley wrote:
> Possibly ... if it's a refcounting bug on the host structure (which
> would cause shost->pool to have bogus data).  However, in that case,
> there should be some reference to freeing the host in the logs above the
> oops (or some event that triggered it).   For just a running system, we
> don't ever free the host structure until all the devices are gone.

I checked the serial port log (I log the serial console from another machine,
to be sure to get these kinds of bugs even if they hit the network and/or
SCSI subsystems), and the only thing is that cron seems to have segfaulted a
time. This is unusual, but I take it it shouldn't crash the kernel in itself
(and it might be due to the result of some glibc up- and downgrading around
that time).

/* Steinar */
-- 
Homepage: http://www.sesse.net/
