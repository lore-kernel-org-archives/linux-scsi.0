From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] ipr: Rename ipr's state scsi host attribute to
	prevent collisions
Date: Mon, 28 Apr 2008 18:50:32 -0400
Message-ID: <1209423032.3367.76.camel@localhost.localdomain>
References: <12094221802009-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48129 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967161AbYD1Wui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 18:50:38 -0400
In-Reply-To: <12094221802009-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, wayneb@linux.vnet.ibm.com, pbadari@linux.vnet.ibm.com

On Mon, 2008-04-28 at 17:36 -0500, Brian King wrote:
> Due to recent SCSI core changes which add a scsi host attribute
> named "state", this now collides with an ipr driver scsi host attribute
> with the same name, preventing ipr from loading. Rename the ipr driver
> attribute to be more specific.

Heh, since the mid-layer state variable was introduced in March 2004 and
then ipr added the one that overwrote it in November 2005, that's an
interesting revision of history.

The actual problem is that recent changes to the device model by Greg
and Kay mean that it no longer silently tolerates this type of attribute
overwriting.

James


