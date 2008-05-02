From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 7/7] aic79xx_core: remove ascii art
Date: Fri, 2 May 2008 14:16:41 -0700
Message-ID: <20080502141641.99fd8c65.akpm@linux-foundation.org>
References: <200805022044.m42Kiv17013977@imap1.linux-foundation.org>
	<1209762632.3121.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754423AbYEBVQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 17:16:45 -0400
In-Reply-To: <1209762632.3121.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 02 May 2008 16:10:32 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2008-05-02 at 13:44 -0700, akpm@linux-foundation.org wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Those '<<<<<<<' lines keep on emitting false-positives when I'm grepping for
> > git conflicts.  Replace them with '='.
> 
> I'm not opposed to this in principle, but I have to ask how?  The grep
> for conflicts remaining in a file is
> 
> egrep '^<<<<<<<|^=======|^>>>>>>' <file>
> 
> Which doesn't match anything in the aic7xxx directory.  If you're
> grepping without the anchor, then you're going to get another match
> looking for ===== with your change, aren't you?

Yeah, I'm being lazy.  Might as well drop it and I'll do more typing :)
