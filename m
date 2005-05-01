From: kallol@nucleodyne.com
Subject: LSI Logic's Ultra320 320-4X RAID adapter
Date: Sat, 30 Apr 2005 21:02:26 -0400
Message-ID: <1114909346.42742aa2a8926@www.nucleodyne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261482AbVEABCU@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Hello,
      We have been evaluting different IO adapters for a storage system vendor.

LSI logic's 320-4X RAID controller seems to be a good choice.

There is an issue with the system on which we are measuring performance.
The memory space PCI register access can not be used.

Question #1: Does 320-4X support IO Space device register access?
Question #2: Do we have a linux driver for it that supports IO ports also?

The megaraid linux driver seems to check the BAR0, if it is memory bar then mem
space is used otherwise IO space.

May be the adapter supporting memory space also support IO space access.


Thanks,
Kallol
