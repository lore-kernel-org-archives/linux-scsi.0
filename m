From: Hans de Goede <hdegoede@redhat.com>
Subject: Logging of all scsi commands to a certain target?
Date: Sat, 23 Aug 2014 16:54:55 +0200
Message-ID: <53F8AB3F.50901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaHWOy5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 10:54:57 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7NEsv4F022214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 10:54:57 -0400
Received: from shalem.localdomain (vpn1-5-5.ams2.redhat.com [10.36.5.5])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7NEstGx031203
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 10:54:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Hi,

Now that the UAS driver is no longer marked as CONFIG_BROKEN,
I'm getting quite a few bug reports about issues with UAS drives.

Some of these seem to be related to the scsi core and/or the sd
driver sending a command the device does not like.

As such I'm wondering if there us a way to get the kernel
to log each scsi command ? Or at least is there a helper
function to log scsi commands which I can add to the uas driver
(under a verbose option) to allow this ?

Regards,

Hans
