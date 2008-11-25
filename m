From: "Rhine, Jay \(Jay\)" <jrhine@alcatel-lucent.com>
Subject: RE: Devices going offline on Adaptec 29320 using driverAIC79XXafter messages "Attempting to queue an ABORT message:CDB"
Date: Tue, 25 Nov 2008 17:22:45 -0600
Message-ID: <CA39D769C8FE694788CE376026984BAB0117D2A3@ILEXC1U01.ndc.lucent.com>
References: <CA39D769C8FE694788CE376026984BAB0117D222@ILEXC1U01.ndc.lucent.com> <1227650031.3415.31.camel@localhost.localdomain> <CA39D769C8FE694788CE376026984BAB0117D26F@ILEXC1U01.ndc.lucent.com> <1227651294.3415.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ihemail2.lucent.com ([135.245.0.35]:62948 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYKYXWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 18:22:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1227651294.3415.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

> Completely normal as in some disk arrays can take 60-120s to process
commands under heavy load ... this depends on disk 
> array though.  The classic one to do this is the EMC symmetrix:  It
has such a massive cache that it can accept I/O at 
> cable rates while spitting it out to the platters at less than this.
It's like a sink filling up until you reach the 
> overflow.  By the time this happens, it can take minutes to get data
from the cable across the cache to the platters 
> causing command timeouts unless the O/S is tuned to accept far longer
timeout intervals.
>
>If it's a bug in the sequencer, it's going to be very hard to fix
without documentation, so I'd hope for the former.
>
>James

What I figured I would try is to decrease the timeout and see if that
makes the error occur more often (since it can easily take 12-24 hours
to reproduce the other error ... at least when I want it to happen :) ).
Is my logic that this should make the error occur more often (if its a
timeout issue) correct?

Thanks,

Jay


