From: Paul Smith <paul@mad-scientist.net>
Subject: Re: Backport of: [SCSI] sg: fix races during device removal--OK?
Date: Mon, 20 Jul 2009 17:49:29 -0400
Message-ID: <1248126569.8762.143.camel@psmith-ubeta.netezza.com>
References: <1247783318.8762.134.camel@psmith-ubeta.netezza.com>
	 <4A607CD5.9050206@cybernetics.com>
Reply-To: paul@mad-scientist.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta.netezza.com ([12.148.248.132]:56876 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751524AbZGTVtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jul 2009 17:49:43 -0400
In-Reply-To: <4A607CD5.9050206@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Fri, 2009-07-17 at 09:29 -0400, Tony Battersby wrote:
> Paul Smith wrote:
> > Hi all.  We are using the current Linux 2.6.27.26 stable kernel on an
> > embedded system.  We are seeing some SCSI issues, and the fix (log entry
> > below) that went into 2.6.28.10 seems relevant.  We backported it to our
> > version of the kernel, as included below.
> >
> > Most things applied without any issue but there were a few areas that
> > had to be changed for 2.6.27; see the marked diffs for sg_release() and
> > sg_common_write().
> >
> > I wonder if anyone has any comments on this: problems with the backport
> > or other issues we might run into.
> >
> > Thanks!
> > 
> I am also using 2.6.27.26 in an embedded system.  Below is the patch
> that I have been using.

Ah!  That works well for us and solves the issues we were seeing.

Thanks Tony!

