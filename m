From: Dave Jones <davej@redhat.com>
Subject: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 00:52:50 -0400
Message-ID: <20060729045249.GA23398@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54212 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1161379AbWG2Ewy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 00:52:54 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k6T4qrBc027027
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jul 2006 00:52:53 -0400
Received: from nwo.kernelslacker.org (vpn-248-9.boston.redhat.com [10.13.248.9])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k6T4qrW2019153
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jul 2006 00:52:53 -0400
Received: from nwo.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by nwo.kernelslacker.org (8.13.7/8.13.5) with ESMTP id k6T4qqag028268
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jul 2006 00:52:52 -0400
Received: (from davej@localhost)
	by nwo.kernelslacker.org (8.13.7/8.13.7/Submit) id k6T4qp8l028267
	for linux-scsi@vger.kernel.org; Sat, 29 Jul 2006 00:52:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

AFAICT, this has been broken since the code to sanitise scsi commands
was added circa 2.6.8 or so.

It seems cdrecord tries to send some vendor specific commands to Plextor
drives, and fails miserably as can be seen here..
https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=124267

I'm not that familiar with this code, but would adding exceptions
on a per-vendor basis in sg_allow_access() be the way forward here?

If not, what is the right answer ?

		Dave

-- 
http://www.codemonkey.org.uk
