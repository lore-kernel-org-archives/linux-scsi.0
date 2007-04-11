From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: SCSI breakage on PowerMac 9500 (oldworld) between 2.6.19.7 and
 2.6.20
Date: Tue, 10 Apr 2007 19:15:34 -0700
Message-ID: <20070410191534.9b443b71.randy.dunlap@oracle.com>
References: <20070410221217.GA21776@galaxy.int.geweb.net>
	<20070410155359.cf82f5ea.randy.dunlap@oracle.com>
	<20070411010850.GA27421@galaxy.int.geweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:16126 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030753AbXDKCNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2007 22:13:46 -0400
In-Reply-To: <20070411010850.GA27421@galaxy.int.geweb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Geier <linux-scsi@ml.martin.geweb.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 11 Apr 2007 03:08:50 +0200 Martin Geier wrote:

> Hi
> 
> On Tue, Apr 10, 2007 at 03:53:59PM -0700, Randy Dunlap wrote:
> > On Wed, 11 Apr 2007 00:12:17 +0200 Martin Geier wrote:
> (..)
> > > Maybe it's connected to http://marc.info/?l=linux-scsi&m=117596425706527&w=2
> > > but my test of 2.6.21-rc5 failed similarly to the test of 2.6.20.
> (..)
> > There was a similar report for the imm driver, with a follow-up
> > report that 2.6.21-rc5 works.  Could you test 2.6.21-rc6?
> I think I saw that one (in case you mean the one mentioned above).
> rc5 (*) didn't work, but fortunately rc6 does work. Do you have any
> idea which commit fixed this (and if I can apply it against 2.6.20.6)?

No, sorry, I don't know what patch fixes it.  I just know that I can
reproduce the failure + fix using the imm driver.


> Martin
> 
> *)
> http://www.de.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.21-rc5.tar.bz2
> vs.
> http://www.de.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.21-rc6.tar.bz2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
