From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 09:21:59 -0600
Message-ID: <1195572119.3131.21.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org>
	 <1195570387.3131.12.camel@localhost.localdomain>
	 <200711201607.06317.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:42127 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760293AbXKTPWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 10:22:05 -0500
In-Reply-To: <200711201607.06317.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>


On Tue, 2007-11-20 at 16:07 +0100, Oliver Neukum wrote:
> Am Dienstag 20 November 2007 schrieb James Bottomley:
> > I don't understand why you want to do this.  Power management is a
> > layered issue on SCSI, divided (as always) into host, device and
> > transport.  The idle you're talking about is a pure device thing, so it
> > can be managed by the ULD (and currently is).  When a unit is stopped,
> 
> The lower layers don't know how to correctly suspend a device. sd_suspend()
> may know how to do it. It would also mean the LLD having to detect idleness.

You really mean you want to involve the transport as well, right?  So
ipso facto this is more than simple idleness management.  Thus, you
really need to look into the full solution (host, transport and ULD).

James


