From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Mon, 28 Jul 2003 20:49:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030729034957.GA2518@praka.local.home>
References: <20030728220836.GA10845@thumper2.emsphone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:56731 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S270426AbTG2Drg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2003 23:47:36 -0400
Received: from san.rr.com (66-75-130-166.san.rr.com [66.75.130.166])
	by orngca-mls02.socal.rr.com (8.11.4/8.11.3) with ESMTP id h6T3hgC18321
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2003 20:43:43 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h6T3nxws002690
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2003 20:50:00 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h6T3nwPJ002689
	for linux-scsi@vger.kernel.org; Mon, 28 Jul 2003 20:49:58 -0700
Content-Disposition: inline
In-Reply-To: <20030728220836.GA10845@thumper2.emsphone.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, 28 Jul 2003, Andrew Ryan wrote:

> Linux is not seeing any devices attached to a CMD CRA-7280 san
> connected raid unit using kernel 2.6.0-test[12] and qlogic drive
> 8.00.00b4.  It works in 2.5.69 with qlogic 8.00.00b3 drivers and the
> b4 drivers (kernel 2.6.0-test1) were able to see devices on a
> Hitachi eval unit we had.  I can't tell if it is the kernel or
> drives since the b4 drivers are needed for the 2.6 kernels and I
> cannot use the b4 drivers in the 2.5.69 kernel.  2.5.75 gives me
> oops problems.   I haven't tried the others.  Any ideas.
> 

Is the midlayer not scanning the devices or does the device driver not
recognize any devices to present to the mid-layer during its scan?
Could you forward along the output of the /proc entries made by the
device driver, for example: /proc/scsi/qla2300/0, ...

	# cat /proc/scsi/qla2300/0
	# cat /proc/scsi/qla2300/1

Does the output of the previous commands represent what you'd expect
given the topology (proper number of targets and luns)?

Regards,
Andrew Vasquez
QLogic Corporation
