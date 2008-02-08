From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 03/13] mptbase: reset ioc initiator during PCI resume
Date: Thu, 07 Feb 2008 18:41:25 -0600
Message-ID: <1202431285.3171.46.camel@localhost.localdomain>
References: <200802050752.m157qsni010694@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33637 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226AbYBHAlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 19:41:52 -0500
In-Reply-To: <200802050752.m157qsni010694@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, djwong@us.ibm.com, "Moore, Eric" <Eric.Moore@lsi.com>

On Mon, 2008-02-04 at 23:53 -0800, akpm@linux-foundation.org wrote:
> From: "Darrick J. Wong" <djwong@us.ibm.com>
> 
> It appears that the LSI SAS 1064E chip needs to be reset after a
> suspend/resume cycle before the driver attempts further communications with
> the chip.  Without this patch, resuming the chip results in this error
> message being printed repeatedly and no more disk I/O.
> 
> mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
> 
> So far it seems to fix suspend/resume on all the MPT Fusion cards I have
> (SAS and U320 SCSI) but since I don't know the internals of that chip I
> can't say for sure if this is a proper fix.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Ping on this, please Eric.

James


