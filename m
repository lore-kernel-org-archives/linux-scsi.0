From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Wed, 25 Feb 2004 00:32:54 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402250024450.3713@kai.makisara.local>
References: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi>
 <20040224170412.GA31268@kroah.com> <1077642529.1804.170.camel@mulgrave>
 <20040224171629.GA31369@kroah.com> <20040224101512.A19617@beaverton.ibm.com>
 <Pine.LNX.4.58.0402242028370.3713@kai.makisara.local> <20040224220946.GA2389@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:2536 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262506AbUBXWc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 17:32:57 -0500
In-Reply-To: <20040224220946.GA2389@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 24 Feb 2004, Greg KH wrote:

> On Tue, Feb 24, 2004 at 11:48:32PM +0200, Kai Makisara wrote:
...
> > convenient. Parsing the st names should really be able to extract at 
> > least two fields. With an external program, anything can be done. Maybe 
> > udev can some day do this internally.
> 
> Well, udev didn't think that anyone would do such a looney thing in
> nameing devices :)
> 
However the SCSI tape names are formed, there are three variables. But 
I see your smiley :-)

> But yes, I'll be glad to fix up udev if you all fix up the tape sysfs
> names to match device.txt.
> 
OK. Unless anyone provides strong arguments for the "new" naming or 
some other naming, I will make tomorrow (or actually later today) a patch 
that changes the sysfs file naming to the one in device.txt.

-- 
Kai
