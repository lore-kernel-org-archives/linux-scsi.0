From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 10/17] scsi: gdth.c use unaligned access helpers
Date: Tue, 7 Oct 2008 13:26:55 -0600
Message-ID: <20081007192654.GJ25780@parisc-linux.org>
References: <200809222156.m8MLum2c032291@imap1.linux-foundation.org> <1223050981.3230.21.camel@localhost.localdomain> <590657100810031024r48b6d52ctce83fb81a41f758@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52006 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYJGT04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 15:26:56 -0400
Content-Disposition: inline
In-Reply-To: <590657100810031024r48b6d52ctce83fb81a41f758@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, bharrosh@panasas.com

On Fri, Oct 03, 2008 at 10:24:22AM -0700, Harvey Harrison wrote:
> On Fri, Oct 3, 2008 at 9:23 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > OK, there are two ways to go on this.  Either we eliminate the current
> > SCSI wrappers for this, or we extend them and use them.  Matthew Wilcox
> > already has a patch for the extensions, so do we have a consensus?
> >
> 
> Pointers to the extensions please.

http://marc.info/?l=linux-scsi&m=121423418922887&w=2

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
