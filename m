From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Qlogic ISP1020 in 2.6?
Date: Mon, 13 Dec 2004 12:01:55 -0800
Message-ID: <20041213200155.GA17906@us.ibm.com>
References: <20041212003334.GC2420@einval.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:3806 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261177AbULMVk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2004 16:40:26 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iBDLePBX018423
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 16:40:25 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBDLePMa188520
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 16:40:25 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBDLeOFD008761
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 16:40:25 -0500
Content-Disposition: inline
In-Reply-To: <20041212003334.GC2420@einval.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve McIntyre <steve@einval.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Dec 12, 2004 at 12:33:58AM +0000, Steve McIntyre wrote:
> I've got an Alpha (COMPAQ Professional Workstation XP1000) with a
> built-in ISP1020. Kernel 2.4.28 runs fine on this system; 2.6.9 gives
> me the following errors:

Try using the qlogic 1280 driver instead (thanks to Christoph and I think
Andrew V), I have these in my .config:

# CONFIG_SCSI_QLOGIC_ISP is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLOGIC_1280_1040=y

That last one is really for both 1040 and 1020 support.

The queue depth is overly deep (255), I think because there is no firmware
and/or nvram support, I haven't figured it out, but I don't generate a lot
of IO on them.

-- Patrick Mansfield
