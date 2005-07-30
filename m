From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sdparm cannot start or stop SATA disks
Date: Fri, 29 Jul 2005 23:54:08 -0400
Message-ID: <42EAF9E0.5000502@pobox.com>
References: <42EA0957.9010408@torque.net> <42EA553A.1070304@pobox.com> <42EAF337.8040601@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:56787 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262808AbVG3DyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 23:54:13 -0400
In-Reply-To: <42EAF337.8040601@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> A further thought about implementing the START STOP
> UNIT SCSI command in libata: the TEST UNIT READY
> SCSI command should become more than just a no-op.

Correct.

	Jeff


