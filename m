From: James Bottomley <James.Bottomley@steeleye.com>
Subject: 2.4 SCSI bug fix tree open
Date: 19 May 2003 13:58:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1053370740.1826.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: marcelo@conectiva.com.br
List-Id: linux-scsi@vger.kernel.org

Several people have complained that 2.4 SCSI bug fixes are getting lost,
so I've opened a bitkeeper tree at

http://linux-scsi.bkbits.net/scsi-misc-2.4

to hold them.

Patches going into this tree should be small, well documented bug fixes
to the current SCSI code (i.e. not driver updates, just bug fixes).

If you want a patch to go in, send it to linux-scsi@vger.kernel.org with
a description of the problem and the fix.

James
