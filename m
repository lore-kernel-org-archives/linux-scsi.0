From: William Chow <lilbilchow@yahoo.com>
Subject: is it ok to receive SIGIO in the same context calling SG code?
Date: Mon, 5 May 2003 12:44:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505194408.31127.qmail@web13808.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web13808.mail.yahoo.com ([216.136.175.18]:49167 "HELO
	web13808.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261247AbTEETbh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 15:31:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The documentation associated with the UNH target
emulator project indicates that the thread which
receives the SIGIO cannot also be the context which
calls SG, e.g. for submitting the async I/O. It states
that "there are certain sections of the SCSI generic
code that do not expect to receive signals". Does
anyone have any information, implementational or even
empirical, that would confirm/refute this?

Thanks for any assistance.

ps: please CC me directly in the response.

__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
