From: Luben Tuikov <ltuikov@yahoo.com>
Subject: SCSI Event notification
Date: Tue, 2 Jan 2007 18:08:44 -0800 (PST)
Message-ID: <514638.63285.qm@web31815.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:47319 "HELO
	web31815.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753615AbXACCIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 21:08:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Being the Application Client, SCSI Core needs entry points
for SCSI Event notifications.

For example, Transport Reset event notification entry is
nowhere to be found.  Although to be fare, for this to exist,
SCSI Core needs to have a concept of SCSI Port and it doesn't
have that.

Currently, SCSI Event notifications are handled by LLDD and/or
Transport Stacks, by either poking into the spaghetti SCSI Core,
or emulating establishment of conditions (modal), which isn't
the business of LLDD and/or Transport Stacks.

Can someone who knows what they are doing whip that up and
submit a patch to this list?  This is needed by newer protocols.
(Newer protocols need a different "host" template than the one
currently being used since 1994, but this is another thread...)

Thanks,
   Luben

