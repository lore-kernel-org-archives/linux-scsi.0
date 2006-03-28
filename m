From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.18 beta
Date: Tue, 28 Mar 2006 15:12:28 -0500
Message-ID: <442998AC.2060909@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:16876 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S932133AbWC1UMt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 15:12:49 -0500
Received: from mtl-hse-ppp199093.qc.sympatico.ca ([65.94.217.157] helo=[192.168.1.103])
	by canuck.infradead.org with esmtpsa (Exim 4.54 #1 (Red Hat Linux))
	id 1FOKYW-00022G-4z
	for linux-scsi@vger.kernel.org; Tue, 28 Mar 2006 15:12:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format (default) which is one line per device and a
"classic" format (like the output of 'cat /proc/scsi/scsi') are
supported.

Version 0.18 beta is available at
http://www.torque.net/scsi/lsscsi.html

This beta is in response to the proposed dropping
of the "generic" symlink in sysfs:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114271599617466&w=2

It also anticipates the dropping of the "tape"
symlink from sysfs.

In both cases the new beta should be backward compatible
to lk 2.6.0

There is also a sg3_utils 1.20 beta at:
http://www.torque.net/sg/  [news section]
that adds the same flexibility to sg_map26 (which also
mines sysfs).

Doug Gilbert
