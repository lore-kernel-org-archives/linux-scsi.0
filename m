From: Andy Grover <agrover@redhat.com>
Subject: [ANNOUNCE] python-sgutils 0.1
Date: Tue, 29 Jan 2013 15:37:43 -0800
Message-ID: <51085D47.9070307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3A2Xhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2013 18:37:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: dgilbert@interlog.com

Hi all,

Just a probably-premature announcement that I'm working on Python
bindings for sg3_utils's libsgutils2.so. The project is here:

https://github.com/agrover/python-sgutils

So far it supports inquiry, mode sense, readcap and report luns. I don't
think it makes sense to go for 100% SCSI cmd coverage (use sg3_utils for
that) but rather to do the parts that are most useful to Python-based
storage management tools.

License: BSD
Developing on Linux, but other platforms also likely to work.

Regards -- Andy
