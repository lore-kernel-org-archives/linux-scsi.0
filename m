From: Jeff Garzik <jgarzik@pobox.com>
Subject: libata update posted
Date: Fri, 12 Sep 2003 23:23:51 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F628DC7.3040308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Just some minor updates.  The main one is that ATA software reset is now 
considered reliable, so it is now the default. 
Execute-Device-Diagnostic bus reset method remains in place and can be 
easily re-enabled with a flag.

libata has also moved (slightly) to a new home:
ftp://ftp.kernel.org/pub/linux/kernel/people/jgarzik/libata/

The latest libata patches for 2.4.x and 2.6.x were uploaded to this URL, 
and future patches will appear in the same location.

Look for more updates this weekend, including bug fixes from Dell and 
Red Hat, and better MMIO support.  And maybe a special surprise.  :)

	Jeff
