From: Steven Dake <sdake@mvista.com>
Subject: what replaces Scsi_Host->select_queue_depths?
Date: Fri, 25 Oct 2002 10:55:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB9858E.7090209@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvista.com (persist.az.mvista.com [10.50.1.246])
	by zipcode.az.mvista.com (8.9.3/8.9.3) with ESMTP id LAA03711
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 11:00:30 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am looking at porting the QLA 2xxx driver that MontaVista has been working
with QLogic on to 2.5.44.  I've removed the select_queue_depths function 
calls
from the init and it seems to work fine.

My question is, what replaces this API?  It looks like this only applies 
to devices
that don't support command tagged queueing (ie: a way to shut off access if
the device doesn't support command tagged queueing).

Has this been genericized somewhere else in the scsi subsystem?

Thanks
-steve

