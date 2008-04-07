From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mptsas problem
Date: Mon, 7 Apr 2008 12:54:21 -0400
Message-ID: <20080407165421.GA10954@animx.eu.org>
References: <20080407010738.GB1952@animx.eu.org> <0631C836DBF79F42B5A60C8C8D4E8229F79FF3@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:54964 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYDGQyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 12:54:31 -0400
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229F79FF3@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Sunday, April 06, 2008 7:08 PM, Wakko Warner wrote: 
> > Moore, Eric wrote:
> > > The other fellow was having his controller go into fault 
> > state, that is not
> > > the case here.   Here commands are not completing back from 
> > [0:0:0:0]
> > > device in the timeout period, typically 30 seconds.   Its 
> > hard to tell from
> > 
> > Is it possible that with queue_depth > 31 was causing the 
> > problem?  I read
> > something about that (32 would cause the device to look like 
> > it was hot
> > unplugged or something.  I did not experience this though, or 
> > if I did, it
> > never said the device came back as I had read)
> > 
> 
> Can you please download lsiutil from here:
> ftp://ftp.lsi.com/HostAdapterDrivers/lsiutil

ftp.lsi.com doesn't exist.

> # ./lsiutil 100 > output
> 
> And send me the 'output'.   I need to see whether NCQ was enabled, and
> what the SATAMaxQDepth was set to.
-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
