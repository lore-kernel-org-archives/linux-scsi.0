From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 79901] [BISECTED]Extremely slow boot on Promise VTrak E610f
 due to sd_mod RSOC usage
Date: Tue, 29 Jul 2014 14:56:49 -0700
Message-ID: <20140729215649.GA10749@infradead.org>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
 <bug-79901-11613-ViyKhyhm4Z@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaG2V4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 17:56:50 -0400
Content-Disposition: inline
In-Reply-To: <bug-79901-11613-ViyKhyhm4Z@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Janusz Dziemidowicz <rraptorr@nails.eu.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2014 at 07:07:51PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=79901
> 
> --- Comment #3 from Janusz Dziemidowicz <rraptorr@nails.eu.org> ---
> I've read that document before creating the patch. Now, I've read it again. I
> must say I'm at a loss. In the patch attached to this bug entry I've already
> included Signed-off-by line.
> Can anyone point precisely what is wrong here?

Everything is fine and I already applied your patch.  Thanks a lot for
debugging the issue and coming up with the patch!

