From: Jeff Garzik <jgarzik@pobox.com>
Subject: scsi compliance tests?
Date: Wed, 07 May 2003 21:39:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB9B543.7000003@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39655 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264363AbTEHB0j
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 21:26:39 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19DaNO-0001TU-En
	for linux-scsi@vger.kernel.org; Thu, 08 May 2003 02:39:14 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Are there any publicly available tools that can be used to test/validate 
the compliance of a SCSI device, as exported via the standard Linux 
kernel SCSI layer?

I'm writing a low-level SCSI driver for Linux, that is essentially a 
SCSI simulator, or translator.

	Jeff



