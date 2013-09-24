From: Ewan Milne <emilne@redhat.com>
Subject: Re: notify userspace of offline -> running transitions
Date: Tue, 24 Sep 2013 15:23:15 -0400
Message-ID: <1380050595.4010.121.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab3IXTXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 15:23:16 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8OJNG5D027511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 15:23:16 -0400
Received: from [10.18.25.104] ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r8OJNFpK028689
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 15:23:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://marc.info/?l=linux-scsi&m=133901769900806&w=2

Can we reconsider applying patch 4 in Mike's set?
The problem still exists, and there was never another
solution proposed as far as I can see.  (I posted a
question about this a while back...)

It is a big issue for people who happen to get a
KOBJ_CHANGE uevent while their iSCSI session happens
to be disconnected for some reason, because udev
will end up removing the /dev/by-xxx links when it
can't access the device.  If there is no subsequent
uevent when the device is available again, the links
are never recreated.

-Ewan


