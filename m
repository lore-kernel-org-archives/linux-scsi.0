From: Anne Mulhern <amulhern@redhat.com>
Subject: /sys/.../enclosure_device:<something> ?
Date: Wed, 13 Jan 2016 11:28:52 -0500 (EST)
Message-ID: <2054826122.7150196.1452702532315.JavaMail.zimbra@redhat.com>
References: <1790412140.7137014.1452701936079.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42858 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbcAMQ2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 11:28:52 -0500
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id u0DGSq8P031680
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2016 11:28:52 -0500
In-Reply-To: <1790412140.7137014.1452701936079.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I'm looking for the most precise information available about the meaning of <something>
and from what it is derived. I'm also interested in what the values in the files in that directory
may mean. Could somebody point me there?

Also, how can there be more than one enclosure_device subdirectory for the same device,
or, alternatively, why isn't <something> stored in a file in the more regularly named directory
/sys/.../enclosure_device?

(It would be nice to be able to obtain the value of <something> using libudev's attribute
lookup facilities, but making that value a part of the specially named directory enclosure_device:<something>
makes such a process especially difficult.)

Thanks,

- mulhern
