From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SAI_READ_CAPACITY_16?
Date: Wed, 06 Apr 2005 14:27:14 -0400
Message-ID: <1112812035.5555.20.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458BFF2211@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11161 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262276AbVDFS1Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 14:27:24 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BFF2211@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

On Wed, 2005-04-06 at 12:00 -0400, Salyzyn, Mark wrote:
> For some reason, sd_read_capacity (in sd.c) in the 2.6.9-5.EL (RHEL4)
> kernel is not issuing the SERVICE_REQUEST_IN+SAI_READ_CAPACITY_16
> command to the queuecommand handler (the handler is not even called),
> even though it instruments up that the command is issued (and returns
> not supported). The READ_CAPACITY call makes it through successfully
> indicating 0xFFFFFFFF capacity to trigger the SAI_READ_CAPACITY_16
> request fine. Could there be a bug in the scsi layers reissuing commands
> reusing the request structure misdirecting the requests?

The person who coded it gave a success report on it ... and I've had
several others since then.

On a 32 bit system, you have to have CONFIG_LBD for it to work.

This code is pretty verbose, what are your kernel traces?

James


