From: Cindy Sweet <cindralla_sweet@yahoo.com>
Subject: Task Management - ABORT command! System Hangs!!
Date: Tue, 23 Apr 2002 11:48:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020423184829.23231.qmail@web20908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I am trying to test the Task Management command,
ABORT.
I have an initiator code where it sends me the
InquiryCommand. To simulate ABORT command, I ignore
the Inquiry Command so that the Initiator would
timeout and issue an ABORT.

The Initiator also behaves the sameway by issuing the
TSK MGMT ABORT command, after that THE WHOLE LINUX
SYSTEM HANGS. Sometimes, it resets and quits
gracefully.

The initiator code is UNH ISCSI initiator code.

Why the system Hangs after the TSK MGMT ABORT
Command??

Please help.

Cindy

__________________________________________________
Do You Yahoo!?
Yahoo! Games - play chess, backgammon, pool and more
http://games.yahoo.com/
