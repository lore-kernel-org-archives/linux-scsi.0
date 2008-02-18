From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Device rescan does not find all new devices
Date: Mon, 18 Feb 2008 15:21:44 -0800
Message-ID: <20080218232144.GB4233@linux.vnet.ibm.com>
References: <OF83B5268C.7E58DEB4-ONC12573F3.0042CD17-C12573F3.0044D81A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46256 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbYBRXXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 18:23:25 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1INNNh0019275
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:23:23 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1INNMRu248932
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:23:22 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1INNMEh001504
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:23:22 -0500
Content-Disposition: inline
In-Reply-To: <OF83B5268C.7E58DEB4-ONC12573F3.0042CD17-C12573F3.0044D81A@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Naeher <MNAEHER@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Markus Naeher <MNAEHER@de.ibm.com> wrote:
> The missing disk is always the first one (LUN 000). I have tested this by 
> changing
> the order of the disks on ESS 2. 
> I have also repeated the test scenario with only one path per disk. 
> In this testcase, I have divided the ESS's on the two Adapters (Adapter 1 
> accesses
> the disks on ESS 1, Adapter 2 those on ESS 2). 
> Sadly, with no change in the result. 
> 
> I think the first thing I would need help with is how to further analyze 
> the problem. 
> 

Output from dmesg with SCSI scan logging on would be helpful. You can use
./scsi_logging_level -s --scan 7 with the script (let me know if you
cannot locate the script) or you can adjust the logging by hand.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
