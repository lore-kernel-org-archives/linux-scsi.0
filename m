From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.21
Date: Wed, 09 May 2007 13:37:02 -0500
Message-ID: <1178735822.3695.46.camel@mulgrave.il.steeleye.com>
References: <1178673459.3737.114.camel@mulgrave.il.steeleye.com>
	 <46420F89.5030202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758552AbXEIShf@vger.kernel.org>
In-Reply-To: <46420F89.5030202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-05-09 at 14:14 -0400, Chuck Ebbert wrote:
> James Bottomley wrote:
> > This should be the second half of the SCSI tree, mainly assorted driver
> > updates and fixes.  The patch is available from:
> > 
> 
> Is Doug Chapman's patch for mptspi going in?
> 
> http://marc.info/?l=linux-scsi&m=117857313402574&q=raw

There's no urgency ... it's a bug fix so it can go in the -rc series as
well.  I'd like Eric to look at it, since I theorise it has exposed a
big problem in the fusion queue handling, so the proposed fix might not
actually be complete.

James
