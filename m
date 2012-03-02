From: scameron@beardog.cce.hp.com
Subject: If abort request comes in for command not known to LLD?
Date: Fri, 2 Mar 2012 09:44:38 -0600
Message-ID: <20120302154438.GE17975@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30595 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283Ab2CBPoj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2012 10:44:39 -0500
Received: from g4t0018.houston.hp.com (g4t0018.houston.hp.com [16.234.32.27])
	by g4t0016.houston.hp.com (Postfix) with ESMTP id 603BA14048
	for <linux-scsi@vger.kernel.org>; Fri,  2 Mar 2012 15:44:39 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g4t0018.houston.hp.com (Postfix) with ESMTP id 50C9E10054
	for <linux-scsi@vger.kernel.org>; Fri,  2 Mar 2012 15:44:39 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scameron@beardog.cce.hp.com


What should the LLD do if an abort request comes into the
abort error handler from the midlayer for a command which is
not known to the LLD?

I see aic7xxx_osm.c handles it in this way in ahc_linux_queue_recovery_cmd():

no_cmd:
        /*
         * Our assumption is that if we don't have the command, no
         * recovery action was required, so we return success.  Again,
         * the semantics of the mid-layer recovery engine are not
         * well defined, so this may change in time.
         */
        retval = SUCCESS;

Is that the right thing to do?  Seems a bit weird, but if that's
the right thing to do, I can do that too.

-- steve


