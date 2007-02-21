From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: initio.h header user confusion
Date: Wed, 21 Feb 2007 09:52:15 -0700
Message-ID: <20070221165215.GB26111@parisc-linux.org>
References: <Pine.LNX.4.63.0702211558220.5167@thor.lan> <20070221162008.GA26111@parisc-linux.org> <Pine.LNX.4.63.0702211632160.5167@thor.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56151 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422679AbXBUQwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 11:52:16 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0702211632160.5167@thor.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srdjan Todorovic <todorovic.s@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 21, 2007 at 04:36:59PM +0000, Srdjan Todorovic wrote:
> I'll recheck the other drivers then. It would seem the only users then
> are initio and sun3*. What's the best thing to do about it?
> Should I keep things as they are with SCSI_ABORT_* or should I
> move them to include/scsi/ or something entirely different?

These drivers ought to be moved away from using SCSI_ABORT_*.  If you
don't have the expertise and hardware to do this, best to leave them
alone.
