From: Luben Tuikov <ltuikov@yahoo.com>
Subject: UASP: updates and merges
Date: Thu, 10 Mar 2011 22:49:02 -0800 (PST)
Message-ID: <206682.3247.qm@web31813.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:35718 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752032Ab1CKGtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 01:49:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>

The USB Attached SCSI Protocol driver (UAS, UASP) saw the following update:

[USB] UASP: TMF IU TTBM can also be reserved
    
If the TMF is not ABORT TASK and not QUERY TASK
then the TTBM field in the TMF IU shall be
reserved.

The branch can be found here off of master:
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

    Luben

