From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Hosting of a git tree for linux-scsi
Date: Sat, 2 Dec 2006 20:07:39 -0800
Message-ID: <20061202200739.649b5566.randy.dunlap@oracle.com>
References: <1165117611.3146.3.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:41281 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S936654AbWLCEHL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 23:07:11 -0500
In-Reply-To: <1165117611.3146.3.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

On Sat, 02 Dec 2006 19:46:51 -0800 Sean Bruno wrote:

> Just curious if there already exists a git tree that is maintained for
> the purposes of patching and pulling.
> 
> If one doesn't exist, is there a place to host it?  I could ask around
> my company and see if we could host it there.

There are already several hosted at www.kernel.org/git/ with
many other Linux git repos.  E.g.,

linux/kernel/git/jejb/scsi-misc-2.6.git 	SCSI fixes for post 2.6.19 	James Bottomley 	7 days ago 	summary | shortlog | log

linux/kernel/git/jejb/scsi-rc-fixes-2.6.git 	SCSI bug fixes for -rc kernels 	James Bottomley 	10 days ago 	summary | shortlog | log

linux/kernel/git/jejb/scsi-target-2.6.git 	Experimental tree for scsi ... 	James Bottomley 	5 months ago 	summary | shortlog | log

Note:  www2.kernel.org/git/ is likely a bit faster than www...

---
~Randy
