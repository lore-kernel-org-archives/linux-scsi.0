From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sdparm cannot start or stop SATA disks
Date: Fri, 29 Jul 2005 12:11:38 -0400
Message-ID: <42EA553A.1070304@pobox.com>
References: <42EA0957.9010408@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:19921 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262631AbVG2QLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 12:11:42 -0400
In-Reply-To: <42EA0957.9010408@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> sdparm uses the START STOP UNIT SCSI command to start
> and stop (spin up and spin down) SCSI devices.
> Currently libata does not implement that SCSI command.
> [Hopefully Jeff contradicts me.]

Correct.

Someone should submit a libata patch for this!

	Jeff


