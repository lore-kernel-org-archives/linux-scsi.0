From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 16:09:47 -0500
Message-ID: <1206133787.2961.52.camel@localhost.localdomain>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org>
	 <1206128662.2961.37.camel@localhost.localdomain>
	 <47E41C50.4020406@garzik.org>
	 <1206133280.2961.45.camel@localhost.localdomain>
	 <47E422F1.7080806@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53389 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756233AbYCUVJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 17:09:53 -0400
In-Reply-To: <47E422F1.7080806@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org


On Fri, 2008-03-21 at 17:04 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > It's fixed, and nothing else is additionally broken by the current fix.
> 
> Other than the newly-inconsistent, exported-to-userspace interface, ITYM.

How is it newly inconsistent?  It can still be used in the manner you
intended it, namely to tell if the CD supports AN or not.  When we add
the new bit, we'll have to add a new file for it anyway.

James


