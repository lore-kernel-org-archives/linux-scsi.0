From: Parav Pandit <paravpandit@yahoo.com>
Subject: state of the I/O memory when arrives at low level HBA driver
Date: Tue, 4 Sep 2007 04:50:19 -0700 (PDT)
Message-ID: <547218.81228.qm@web30103.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30103.mail.mud.yahoo.com ([209.191.69.35]:31945 "HELO
	web30103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752137AbXIDLuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2007 07:50:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

This may be petty question, but I am not really sure
about this.

When a I/O comes to the low level SCSI HBA driver
through enqueue() interface, 

can it happen that I/O data memory is paged out or can
be paged out?

I mean, doing DMA mapping such as pci_map_single()
provides, just physical addresses or it also (page-in
if requires) followed by locking the page(s) in the
system?

Regards,
Parav Pandit



       
____________________________________________________________________________________
Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  
