From: Scott O'Connor <soconnor@sanblaze.com>
Subject: scsi_transport_sas and device hotplug
Date: Fri, 19 May 2006 09:29:47 -0400
Message-ID: <446DC84B.1070203@sanblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gazungle.com ([207.210.240.68]:49883 "HELO
	mail.gazungle.com") by vger.kernel.org with SMTP id S1751330AbWESN3s
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 09:29:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a question about this transport layer and SAS Hot plugging.

With a LSI1068 (SAS) card, I'm trying to do device hotplug.
Back in the day I used the /proc calls below to hotplug a device.

scsi remove-single-device <args>
scsi add_single-device <args>

With 2.6.16-1 kernel, the "remove" call below works, the /dev/sd*
structure is removed.

echo scsi remove-single-device 0 07 00 00 > /proc/scsi/scsi

However, this does not add the device back (the /dev/sd* node
is not created):

echo scsi add-single-device 0 07 00 00 > /proc/scsi/scsi

I see the scsi_proc.c to scsi_transport_sas.c user_scan transport
layer code and it seems hooked up properly.  Before I debug, has
anyone else seen a problem here?

Thanks for any help,
-Scott.
