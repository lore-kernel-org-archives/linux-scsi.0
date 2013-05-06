From: Ewan Milne <emilne@redhat.com>
Subject: Re: notify userspace of offline -> running transitions
Date: Mon, 06 May 2013 15:45:33 -0400
Message-ID: <1367869533.3319.13.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3EFTpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 15:45:35 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r46JjYss000399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 6 May 2013 15:45:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kay@redhat.com

http://marc.info/?l=linux-scsi&m=133769378525796&w=2

Did anything ever happen with this?  I don't see that it did.

There seems to be a problem with udev processing an event
for a device at a time when the device can't be accessed.
Mike's original fix was to generate another KOBJ_CHANGE
event when the device comes back online, so that subsequent
udev rule processing would succeed.  Even so, the device
could become inaccessible again by the time the event was
actually processed by udev (if udevd was overloaded...)

-Ewan




