From: Hans de Goede <hdegoede@redhat.com>
Subject: Debugging scsi abort handling ?
Date: Sat, 23 Aug 2014 16:52:24 +0200
Message-ID: <53F8AAA8.8040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaHWOw1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 10:52:27 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7NEqQCs011422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 10:52:26 -0400
Received: from shalem.localdomain (vpn1-5-5.ams2.redhat.com [10.36.5.5])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7NEqO8C028765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 10:52:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Hi All,

Now that the UAS driver is no longer marked as CONFIG_BROKEN,
I'm getting quite a few bug reports about issues with UAS drives.

One if the issues is that there might be a number of bugs in the
abort handling path, as I don't think that was ever tested properly.

So I'm wondering is there a way to test the abort path with a real
drive? E.G. submit some command which is known to take a significant
amount of time, and then abort it right after submitting ?

Thanks & Regards,

Hans
