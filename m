From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: lpfc: System freezing if fiber is broken
Date: Tue, 26 Jul 2005 11:48:00 -0700
Message-ID: <20050726184800.GA19810@us.ibm.com>
References: <42E679A2.1060408@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:10146 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261994AbVGZSsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 14:48:14 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j6QImCwU011532
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 14:48:12 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j6QImCdI121492
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 14:48:12 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j6QImCgX004274
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 14:48:12 -0400
Content-Disposition: inline
In-Reply-To: <42E679A2.1060408@fujitsu-siemens.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Bodo Stroesser [bstroesser@fujitsu-siemens.com] wrote:
> Hi James,
> 
> disrupting a working FC connection makes my i386 SMP server
> (2.6.12.2) freeze just one or two seconds after this.
> I'm normally using lpfc_nodev_tmo = 1. When I change this to the
> default value of 35, the system stalls about 36 seconds after
> disruption. So I guess, the problem is caused by nodev_tmo
> expiring.
> I activated the nmi_watchdog, but no output.
> 
> What can I do to analyze this problem?

Does changing the timeout for a scsi device also alter the problem. In the
past people have seen issues of the nodev_tmo expiring near the scsi
timeout. This past cases lead to devices being offlined, but may this
could be causing a different symptom on your system.

You can change the timeout for the device by echoing a higher value into
/sys/bus/scsi/devices/${nexus}/timeout.

Is this a full system freeze or only the controlling console?

-andmike
--
Michael Anderson
andmike@us.ibm.com
