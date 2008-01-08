From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 08 Jan 2008 19:06:56 +0100
Message-ID: <4783BBC0.2070802@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0801081006580.2643-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:32831 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYAHSHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 13:07:55 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801081006580.2643-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Alan Stern wrote:
> On Tue, 8 Jan 2008, Oliver Neukum wrote:
>> Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
>> >  /**
>> > + *     autoresume - perform dynamic (runtime) host resume
[...]
>> This seems to be a bit misleading. It seems to me that you must cancel
>> any outstanding request to autosuspend from other layers.
> 
> How about something more like this:
> 
> *	Resume (return to an operational power level) the specified host,
> *	and prevent autosuspends from other software layers until the
> *	template autosuspend method has been called again.
> *	Return 0 if the resume was successful, otherwise a negative
> *	error code.

Who prevents them?  The autoresume() implementation, or its caller?
-- 
Stefan Richter
-=====-==--- ---= -=---
http://arcgraph.de/sr/
