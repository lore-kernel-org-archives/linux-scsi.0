From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Fri, 23 Mar 2012 00:26:23 +0100
Message-ID: <20120323002623.6ce2723b@stein>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	<20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
	<20120322143959.GF19835@kroah.com>
	<CABE8wwtyxJaSfZREKRLDTZEef3nk=b+RFSe9i_UmV9knbQJ-tg@mail.gmail.com>
	<20120322235133.269b74b8@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59800 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2CVX07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 19:26:59 -0400
In-Reply-To: <20120322235133.269b74b8@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Mar 22 Stefan Richter wrote:
> On Mar 22 Williams, Dan J wrote:
> > the patches that *fix* this warning are here [1] and here
> > [2].
> [...]
> > [1]: http://marc.info/?l=linux-scsi&m=133239707903443&w=2
> > [2]: http://marc.info/?l=linux-scsi&m=133239709603452&w=2
> 
> Isn't this something which is to be accomplished by counting references to
> the parent device?

Oh, OK, it is about ensuring device_add(parent) -- device_add(child) --
device_del(child) -- device_del(parent) nesting order.  So not just
counting of plain references but a wait-for-completion type issue.
-- 
Stefan Richter
-=====-===-- --== =-===
http://arcgraph.de/sr/
