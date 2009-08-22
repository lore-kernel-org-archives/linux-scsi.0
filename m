From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Sat, 22 Aug 2009 16:50:37 +0100
Message-ID: <20090822155037.GB28586@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com> <20090821092326.GF32115@arachsys.com> <1250863216.3844.1.camel@mulgrave.site> <20090821145141.GR32115@arachsys.com> <1250869674.7363.89.camel@mulgrave.site> <20090822115535.GB1976@arachsys.com> <1250952965.18902.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:39203 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbZHVPuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 11:50:37 -0400
Content-Disposition: inline
In-Reply-To: <1250952965.18902.2.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> Actually, if that works, I'll have the above backported as well.

Hi James. That's much better; thanks! I certainly can't provoke any problems
with it in a VM, although I couldn't really reproduce the problem with the
original kernel in a test environment either. I'll push it to our clusters
and see how things go over the next week or so.

Cheers,

Chris.
