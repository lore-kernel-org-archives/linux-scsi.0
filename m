From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Nasty changes in SCSI driver code
Date: 31 Oct 2002 18:49:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1036090174.8584.88.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Will whoever committed code that simply deleted the error handling from
ncr53c8xxx, sym53c8xx and inia100 please put it back or at least add a 

#warning "Don't use this driver"

SCSI with no error handling is asking for corruption and not warning
users about this as we try and stabilize the kernel is a very very bad
idea. If it warns or doesnt compile then it can get fixed properly. If
it doesnt warn it may get missed with catastrophic results
