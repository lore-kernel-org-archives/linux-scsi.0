From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] aic94xx: sas code clean-up
Date: Wed, 10 May 2006 08:21:44 +0100
Message-ID: <20060510072144.GA14849@infradead.org>
References: <1147209211.11847.33.camel@localhost.localdomain> <20060510065342.40733.qmail@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56252 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964839AbWEJHVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 03:21:50 -0400
Content-Disposition: inline
In-Reply-To: <20060510065342.40733.qmail@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 09, 2006 at 11:53:42PM -0700, Luben Tuikov wrote:
> --- Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> > These patches were created in response to the comments from this earlier
> > email: 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=114624643916659&w=2
> > 
> > First off, thank you Christoph for your comments.  I am working to
> > address them, starting with the ones that are easiest to implement.
> > Follows is a set of patches that address the following concerns:
> > 
> > 1) Move the sas readme to the Documents dir-- this still needs to be
> > written so that it 'matches reality', but I want to merge the sas*.h
> 
> Which "reality" is this?  Christoph's?

s/reality/the code in the tree/ if you prefer.  That code is originally
from you with lots of changes from James, Alexis, Mike and Jeff.

If you call documenting the interfaces actually implemented in the code
"Christoph's reality", then yes it should match Christoph's reality.

