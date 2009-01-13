From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: fix /proc memory leak in the SCSI core
Date: Tue, 13 Jan 2009 10:59:48 -0600
Message-ID: <1231865988.4519.17.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0812011024430.2212-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56887 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbZAMQ7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 11:59:51 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812011024430.2212-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2008-12-01 at 10:26 -0500, Alan Stern wrote:
> Can somebody check to make sure this is compatible with legacy drivers 
> using the non-hotplug API?

I have this one marked for inclusion pending confirmation of this
request ... has anyone tried it?

James


