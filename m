From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: 22 Jan 2004 12:22:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074792163.2149.12.camel@mulgrave>
References: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com>
	<4010034A.3040903@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:48580 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266305AbUAVRWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 12:22:47 -0500
In-Reply-To: <4010034A.3040903@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-22 at 12:07, Brian King wrote:
> Because the device is reported to the LLDD by the adapter as a
> specific device type. The adapter creates a configuration table
> describing all attached devices that the LLDD must retrieve. In this
> configuration table there are several types of devices:

If you can't ever get access to these devices and you only want sg
access for SCSI command ioctls, you could just alter the device type to
something like PROCESSOR (or even an unclassified type) which will solve
the error messages from sd problem.

The true solution to this issue looks to be more flexibility in the
binding process.  We did discuss this previously, certainly in a SAN
environment there are reasons for only actually binding (and allocating
resources to) devices you're interested in.

James


