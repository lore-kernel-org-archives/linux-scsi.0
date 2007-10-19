From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Date: Thu, 18 Oct 2007 22:30:23 -0700
Message-ID: <20071018223023.d805c8c4.akpm@linux-foundation.org>
References: <20071019150431.996522c5.sfr@canb.auug.org.au>
	<20071018222017.514df7b9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbXJSFaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 01:30:39 -0400
In-Reply-To: <20071018222017.514df7b9.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 18 Oct 2007 22:20:17 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 19 Oct 2007 15:04:31 +1000 Stephen Rothwell wrote:
> 
> > At least for now.
> 
> Please explain "why" in the changelog (what changelog?).
> 
> E.g.:
> so that make allmodconfig on powerpc will have a better chance
> of building.

My version of this patch does that.  I'll be sending it into Linus in an
hour or so.
