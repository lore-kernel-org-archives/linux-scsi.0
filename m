From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 21 May 2005 13:12:24 -0500
Message-ID: <1116699144.4999.37.camel@mulgrave>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
	 <1116687698.4999.3.camel@mulgrave> <428F55F1.3090006@pobox.com>
	 <1116691256.4999.16.camel@mulgrave>
	 <20050521162220.GU29811@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:20194 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261756AbVEUSMp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 14:12:45 -0400
In-Reply-To: <20050521162220.GU29811@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, 2005-05-21 at 17:22 +0100, Al Viro wrote:
> Tell that to firmware authors, why don't you?

I do ... but they don't listen ...
 
> > Does anyone actually have one of these RBC devices and does it reject
> > the six byte mode sense commands?
> 
> Yes, will check and do not expect the results to apply to other devices...

Thanks ... I'd be surprised if the entire class of RBC devices simply
ignored the standard; I wouldn't be surprised to find one or two that
are out of spec.

James


