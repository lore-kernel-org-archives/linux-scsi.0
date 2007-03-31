From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx driver woes
Date: Sat, 31 Mar 2007 11:01:53 -0700
Message-ID: <460EA211.2060501@us.ibm.com>
References: <460E90F3.9070601@torque.net>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53906 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXCaSBw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Mar 2007 14:01:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2VI1oWV015218
	for <linux-scsi@vger.kernel.org>; Sat, 31 Mar 2007 14:01:50 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2VI1o9b311398
	for <linux-scsi@vger.kernel.org>; Sat, 31 Mar 2007 14:01:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2VI1omQ018328
	for <linux-scsi@vger.kernel.org>; Sat, 31 Mar 2007 14:01:50 -0400
In-Reply-To: <460E90F3.9070601@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:

> So that is almost 12 months that I have been reporting
> this driver as broken. Is it just me or my hardware?

I seem to recall you saying that the LSI Fusion card was plugged into
the same expander as the 48300?  If so, does unplugging the Fusion card
from the expander make it work?

> aic94xx: Found sequencer Firmware version 1.1 (V17/10c6)

Have you tried the V30 sequencer?

--D
