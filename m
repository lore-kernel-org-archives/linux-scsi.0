From: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: disk restart failure after suspend
Date: Mon, 19 Oct 2009 22:28:28 +0200
Message-ID: <20091019202828.GA26338@mac.home>
References: <Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org>
 <4ADCCB0B.6060005@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:46109 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZJSU2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 16:28:32 -0400
Received: from mac.home (port-212-202-40-61.dynamic.qsc.de [212.202.40.61])
	by eazy.amigager.de (Postfix) with ESMTP id 234DDC8C10E
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 22:28:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <4ADCCB0B.6060005@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Mon, Oct 19, 2009 at 22:24:43 +0200, Stefan Richter wrote:

[...]

> > No.  All it does is cause an error message to be printed in the system 
> > log.  But it's possible that a failure lower down in the SCSI stack has 
> > this effect.
> 
> I wonder what this might be.

I my case, XFS threw a lot of errors because of an incaccessible device
and set the filesystem offline.

Regards,
Tino
