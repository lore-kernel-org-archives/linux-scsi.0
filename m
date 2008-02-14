From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Advansys regression between 2.6.23.8 and 2.6.24.2
Date: Thu, 14 Feb 2008 09:50:58 -0600
Message-ID: <1203004258.3189.20.camel@localhost.localdomain>
References: <20080214161024.2a0c0f17@crazy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42744 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604AbYBNPvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 10:51:04 -0500
In-Reply-To: <20080214161024.2a0c0f17@crazy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, gregkh@suse.de, chrisw@sous-sol.org

On Thu, 2008-02-14 at 16:10 +0100, Thomas Petazzoni wrote:
> I just upgraded my system from 2.6.23.8 to 2.6.24.2, and when loading
> the advansys module, it paniced, with "Kernel BUG at advansys.c:6335".
> The issue is that the overrun buffer is not aligned on 8 bytes.
> 
> The patch 7d5d408c77cee95d1380511de46b7a4c8dc2211d [1], by FUJITA
> Tomonori, which has been committed a few days ago, fixes the issue. The
> commit log says that the structure should be 8-byte aligned on 2.6.23
> and 2.6.24, but it doesn't seem to be the case in 2.6.24. I have not
> identified which commit broke the driver, but I confirm that Tomonori's
> patch fixes the problem.
> 
> I've added Greg and Chris as Cc: because such a patch should probably
> be included in the next -stable of 2.6.24, but of course Tomonori and
> Matthew are best placed to say what should be done.

Yes, it's already on its way to stable.  The process requires the fix to
be committed upstream first.  There's an automated script that sends
these commits back to stable once they're upstream (provided they're
tagged correctly).

James


