From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [RFC, PATCH v2] SCSI tape: MTIOCSENSE ioctl to return the sense
 data from errors
Date: Mon, 21 Jul 2008 22:27:04 +0300 (EEST)
Message-ID: <alpine.LNX.1.10.0807212216270.20236@kai.makisara.local>
References: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>  <alpine.LNX.1.10.0807131723510.16437@kai.makisara.local> <1216657840.3433.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:58731 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYGUT1K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2008 15:27:10 -0400
In-Reply-To: <1216657840.3433.38.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Arne Wiebalck <arne.wiebalck@cern.ch>

On Mon, 21 Jul 2008, James Bottomley wrote:

> On Sun, 2008-07-13 at 17:24 +0300, Kai Makisara wrote:
> > Here is the second version of the proposed MTIOCSENSE patch. The changes from
> > the first version are:
> > 
...
> > The patch below this text applies to 2.6.26-rc9 plus the two bug fixes I have
> > sent to linux-scsi (applies with offsets without these fixes).
> 
> You listed this as an RFC, so I haven't done anything with it but if you
> want this in for 2.6.27 you'd better change that to a proper PATCH
> before the merge window closes.
> 
I think it has to wait until 2.6.28. This is a new ioctl and it is better 
to wait for more feedback to be sure that the definition is what users 
really need.

Kai
