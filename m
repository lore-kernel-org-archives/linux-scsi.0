From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI git trees
Date: Mon, 03 Aug 2009 19:00:08 +0000
Message-ID: <1249326008.3943.210.camel@mulgrave.site>
References: <1248887256.3900.78.camel@mulgrave.site>
	 <19063.9181.620137.814464@stoffel.org>
	 <20090803110911.37044826.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44456 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbZHCTAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 15:00:10 -0400
In-Reply-To: <20090803110911.37044826.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: John Stoffel <john@stoffel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-08-03 at 11:09 -0700, Randy Dunlap wrote:
> On Mon, 3 Aug 2009 13:52:29 -0400 John Stoffel wrote:
> 
> > >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > 
> > James> It seems I got unsubscribed from linux-scsi last week while I was on
> > James> holiday and I've likely missed a slew of patches, it seems like an
> > James> appropriate time to remind everyone how the SCSI trees work.
> > 
> > James> ---
> > 
> > James> There are two git based scsi trees:
> > 
> > James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git
> > 
> > James> called the scsi-misc tree for patches being collected for the
> > James> next merge window.  And
> 
> James,
> Would it help you for patchwork to capture linux-scsi patches?
> either patchwork.kernel.org or patchwork.ozlabs.org

Well, SCSI was supposed to be one of the consumers of patchwork;
evidently we fell through the cracks.

However, it's not really going to help me that much because my MO is to
do most of my tree work offline (while travelling).  Patchwork, being a
web based tool doesn't work well offline, so I need to keep on with my
email based workflow. (On the other hand evolution in its latest
incarnations is taking a very cavalier attitude to the "download
messages for offline use" flag ... if it gets much worse I'll lose my
offline work ability anyway).

James


