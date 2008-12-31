From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: mvsas: increase port type detection delay to suit
	Seagate's 15k6 drive ST3450856SS 0003
Date: Wed, 31 Dec 2008 10:14:15 -0600
Message-ID: <1230740055.3408.88.camel@localhost.localdomain>
References: <00cd01c96a1b$240d6a50$6602a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54431 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbYLaQOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2008 11:14:18 -0500
In-Reply-To: <00cd01c96a1b$240d6a50$6602a8c0@bui.materna.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland <devzero@web.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kewei@marvell.com, rnissl@gmx.de

On Tue, 2008-12-30 at 02:08 +0100, Roland wrote:
> as this driver is relatively new, is it already stable enough for production 
> use ?

It passes my testing, including some nicely error prone expander
configurations ... however, I assume you'll put it through its
qualification paces.

> i thought about buying a mobo with marvell sas controller.
> 
> is it planned to merge this patch, as it is fixing a problem or must this 
> problems being workarounded in userspace ?

Ideally, I'd like marvell to comment on this since just increasing the
timer looks like it's hiding some type of race in the driver ...
however, since it's been around for nearly a month now with no response
and it looks relatively harmless, I'll put it in.

> here`s some more with that problem:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=474482
> http://forumubuntusoftware.info/viewtopic.php?f=46&t=2454

James


