From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: SG_IO permissions
Date: Thu, 03 Jul 2008 10:06:30 -0500
Message-ID: <1215097591.3309.1.camel@localhost.localdomain>
References: <1215004850.5058.101.camel@pcitfio23.cern.ch>
	 <1215010262.3330.19.camel@localhost.localdomain>
	 <E7F3663B89B60B478C6997C0A0671F8B0D58A9@cernxchg45.cern.ch>
	 <E7F3663B89B60B478C6997C0A0671F8B0D58AB@cernxchg45.cern.ch>
	 <1215030534.3330.46.camel@localhost.localdomain>
	 <1215076505.5058.146.camel@pcitfio23.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48448 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbYGCPGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2008 11:06:41 -0400
In-Reply-To: <1215076505.5058.146.camel@pcitfio23.cern.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Wiebalck <arne.wiebalck@cern.ch>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-07-03 at 11:15 +0200, Arne Wiebalck wrote:
> > > >Should the user process get CAP_SYS_RAWIO?
> > > 
> > > The user process in my case is forked by another process which runs
> > > as root. But since this process does not have CAP_SETPCAP it cannot
> > > set the child's capabilities (which is how I naively thought one could 
> > > implement this).
> > > 
> > > What options are left? Running a patched kernel where the "SG_IO in st
> > > requires CAP_SYS_RAWIO" is taken out?
> > 
> > Erm, well capabilities are designed to be malleable, especially with
> > things like sucap and execap, which root should be able to use.
> 
> But you need to change and recompile your kernel to use that, as init
> needs CAP_SETPCAP to be set, no?

Well .. how you do that isn't really a SCSI problem.  The FAQ has one
solution.  I suppose rebuilding your kernel is another possible but
inelegant one.

James


