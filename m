From: Greg KH <greg@kroah.com>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Tue, 24 Feb 2004 09:55:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224175515.GA31715@kroah.com>
References: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi> <20040224170412.GA31268@kroah.com> <1077642529.1804.170.camel@mulgrave> <20040224171629.GA31369@kroah.com> <Pine.LNX.4.58.0402241937450.3713@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:60841 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262354AbUBXSHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 13:07:00 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402241937450.3713@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Feb 24, 2004 at 07:51:42PM +0200, Kai Makisara wrote:
> On Tue, 24 Feb 2004, Greg KH wrote:
> 
> > On Tue, Feb 24, 2004 at 11:08:48AM -0600, James Bottomley wrote:
> > > On Tue, 2004-02-24 at 11:04, Greg KH wrote:
> > > > Can you post it here so we can review it?
> > > > 
> > > > And yes, using class_simple should relieve you of Al flamage :)
> > > 
> > > The one in the tree is attached.  I did verify it myself, and tried it
> > > out on some old QIC tapes I had lying around.
> > 
> > Can you print out the sysfs tree this patch creates?
> > 
> Here is a partial tree for the first tree (nearly identical entries from 
> the middle trimmed):

<snip>

Ah, very nice.  And thanks for adding those symlinks back to the class
entries, that should be helpful for people.

Looks good.

greg k-h
