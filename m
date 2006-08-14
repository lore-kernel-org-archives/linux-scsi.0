From: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: aic7xxx broken in 2.6.18-rc3-mm2
Date: Mon, 14 Aug 2006 10:04:32 -0700
Message-ID: <1155575073.7574.162.camel@localhost.localdomain>
References: <1155334308.7574.50.camel@localhost.localdomain>
	 <200608130002.40223.daniel.ritz-ml@swissonline.ch>
	 <1155571551.7574.143.camel@localhost.localdomain>
	 <200608141858.37465.daniel.ritz-ml@swissonline.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:28299 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932212AbWHNREy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 13:04:54 -0400
In-Reply-To: <200608141858.37465.daniel.ritz-ml@swissonline.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Greg KH <greg@kroah.com>, Marcus Better <marcus@better.se>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux scsi <linux-scsi@vger.kernel.org>, ak@suse.de

On Mon, 2006-08-14 at 18:58 +0200, Daniel Ritz wrote:
> On Monday 14 August 2006 18.05, Dave Hansen wrote:
> > On Sun, 2006-08-13 at 00:02 +0200, Daniel Ritz wrote:
> > > Dave, your SCSI card should work with this as well :)
> > 
> > Sorry, it has the same behavior as without the patch.  If it matters,
> > here is the relevant portion of my .config:
> 
> hmm..should be 2.6.16 behavior with this...
> what kind of box is this?

IBM 4-way PIII Xeon.  5 years old or so.

> could you give me dmesg output of plain 2.6.18-rc4
> and a 2.6.18-rc4 with the patch (not -mm if possible)?

The patch you just sent, or the original one that went into -mm?  (You
could just attach whatever you want me to test to your reply, and that
way I _can't_ screw it up ;)

-- Dave

