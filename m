From: Michael Heinz <mheinz@infiniconsys.com>
Subject: Asynchronous Event Reporting
Date: Tue, 16 Apr 2002 08:30:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBC196A.2050803@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'd like to do a quick sanity check here...

I've been asked to make sure I support async event reporting in the 
driver I'm working on (which will eventually be GPL! Honest! :-P).

 From reviewing the code in 2.4 scsi/drivers it appears that the best I 
can do is log that I got the event, but then ignore it - sd.c does not 
support AER.

Is this correct?

-- 
knock knock.

Michael Heinz <mheinz@infiniconsys.com>


