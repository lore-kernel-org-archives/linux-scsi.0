From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: fix /proc memory leak in the SCSI core
Date: Tue, 13 Jan 2009 12:16:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901131216290.2667-100000@iolanthe.rowland.org>
References: <1231865988.4519.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40033 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753221AbZAMRQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 12:16:50 -0500
In-Reply-To: <1231865988.4519.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 13 Jan 2009, James Bottomley wrote:

> On Mon, 2008-12-01 at 10:26 -0500, Alan Stern wrote:
> > Can somebody check to make sure this is compatible with legacy drivers 
> > using the non-hotplug API?
> 
> I have this one marked for inclusion pending confirmation of this
> request ... has anyone tried it?

Not that I've heard.

Alan Stern

