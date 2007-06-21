From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 21 Jun 2007 17:03:09 +0200
Message-ID: <20070621150308.GA29643@schmichrtp.de.ibm.com>
References: <200706191025.30986.swen@vnet.ibm.com> <20070619171217.GA30099@infradead.org> <1182307586.10507.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:45056 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXFUPDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 11:03:35 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l5LF3YZE094854
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 15:03:34 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5LF3Xi12424948
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 16:03:33 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5LF3XlG009643
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2007 16:03:33 +0100
Content-Disposition: inline
In-Reply-To: <1182307586.10507.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Now that everybody is happy with using the FCP LUN in the SCSI
midlayer, this raises a question from the user's perspective:

sysfs and lsscsi display the LUN as decimal number. For the FCP LUN
0x401040c300000000, sysfs and lsscsi display this:

$ ls -l /sys/bus/scsi/devices/
total 0
lrwxrwxrwx 1 root root 0 Jun 21 16:49 0:0:0:1086537744 ->
../../../devices/css0/0.0.0010/0.0.181d/host0/rport-0:0-0/target0:0:0/0:0:0:1086537744

$ lsscsi
[0:0:0:1086537744]disk    IBM      2107900          .270  /dev/sda

Asking a system admin to translate the number to hex (0x40C34010) and
then swap the pairs to get the real FCP LUN (0x401040c3) is too much.

Are there any plans to improve this? Showing the LUN in sysfs as hex
number would be the first step. Or does it make more sense to keep the
decimal number in sysfs and let tools like lsscsi do the conversion?

--
Christof Schmitt
