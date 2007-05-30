From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH 1/3] zfcp: IO stall after path checker changes
Date: Wed, 30 May 2007 08:36:11 +0200
Message-ID: <200705300836.11645.swen@vnet.ibm.com>
References: <200705291529.39677.swen.schillig@freenet.de> <1180453916.3700.29.camel@mulgrave.il.steeleye.com> <1180454082.3700.32.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:45150 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXE3GdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 02:33:02 -0400
In-Reply-To: <1180454082.3700.32.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, mloehr2@linux.vnet.ibm.com

On Tuesday 29 May 2007 17:54, James Bottomley wrote:
> On Tue, 2007-05-29 at 10:51 -0500, James Bottomley wrote:
> > On Tue, 2007-05-29 at 15:55 +0200, Swen Schillig wrote:
> > > I just saw that I posted this patch on 9th already, 
> > > but todays git pull from your tree didn't show the inclusion of this one (and another patch posted the same day).
> > > Event though it's reported in your summary from the 26 !
> > > If I'm to quick then I'm sorry for sending it twice, if there's any other
> > > reason for this patch to not be included please let me know.
> > 
> > Sorry ... must have missed it.  I'll add it to rc-fixes (unfortunately I
> > need linus to pull before I can push into this tree, so there'll be a
> > slight delay).
> 
> Actually, forget that; this is it, isn't it?
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=9f28745a6b554fdd6b0dbc9856077701a55f9569
> 
> In which case it's awaiting a pull into Linus' tree head.
> 
> James
> 
> 
Yeah, that's it.

Thanks.

Swen
