From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 17:01:46 +0200
Message-ID: <20101025150146.GA477@apartia.fr>
References: <20101023095816.GA19791@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com>
 <20101025131937.GA6605@apartia.fr>
 <20101025154705.73d49860@harpe.intellique.com>
 <20101025135647.GA14302@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F771@cosmail02.lsi.com>
 <20101025140905.GA20569@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F783@cosmail02.lsi.com>
 <20101025142559.GA25269@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F799@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:54140 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0JYPBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 11:01:48 -0400
Received: from sylla.apartia.fr (sylla.apartia.fr [10.0.3.3])
	by zenon.apartia.fr (Postfix) with ESMTP id 21A3542497004
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 17:01:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3010111F799@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Oct 25, 2010 at 08:27:42AM -0600, Yang, Bo wrote:
> You are right.  Ctrl-R for PERC... and ctrl-H for LSI.

OK, I tried Ctrl-H during adapter post and nothing (apparently)
happened.

However my syslog has:

	scsi2 : LSI SAS based MegaRAID driver
	Oct 25 14:48:27 grml kernel: [    1.956381] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72101 A70M PQ: 0 ANSI: 5

Does that "Direct-Access" mean I'm now in JBOD mode?

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Louis-David Mitterrand
> Sent: Monday, October 25, 2010 10:26 AM
> To: linux-scsi@vger.kernel.org
> Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
> 
> On Mon, Oct 25, 2010 at 08:11:14AM -0600, Yang, Bo wrote:
> > Does the ctrl^H work for you?
> > 
> 
> Oh, you mean Ctrl-H, not the usual Ctrl-R.
> 
> Is that a secret cheat code (like in Doom :-) ?
> 
> I'll try it a soon as my raid6 partition finishes resync'ing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
