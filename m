From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 7980] New: scsi_wait_scan module should be
 always available
Date: Fri, 9 Feb 2007 17:28:34 -0800
Message-ID: <20070209172834.8276d104.akpm@linux-foundation.org>
References: <200702100114.l1A1EC7r023423@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59205 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXBJB2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 20:28:43 -0500
In-Reply-To: <200702100114.l1A1EC7r023423@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, holler@ahsoftware.de

On Fri, 9 Feb 2007 17:14:12 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7980
> 
>            Summary: scsi_wait_scan module should be always available
>     Kernel Version: 2.6.20
>             Status: NEW
>           Severity: normal
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: holler@ahsoftware.de
> 
> 
> The scsi_wait_scan module should be always available, even if scsi was build 
> into the kernel (not as module). E.g. I'm having two scsi-controllers in one 
> machine, one as module and one from which the machine is booting. Currently 
> this does not work, because I'm getting failures for devices of the driver 
> which is build as a module. And because scsi is not build as module, the 
> scsi_wait_scan module is not available.
> 
