From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6 api host private area?
Date: Thu, 17 Jul 2003 14:45:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F16EEE6.5060306@pobox.com>
References: <3F16EE8A.20203@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:17555 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271543AbTGQSbP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 14:31:15 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19dDlY-0001FN-JD
	for linux-scsi@vger.kernel.org; Thu, 17 Jul 2003 19:46:08 +0100
In-Reply-To: <3F16EE8A.20203@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Where is the pointer for the scsi_host_alloc private area stored?


Nevermind, I see ->hostdata at the end of the struct.

Alignment issues remain, though.

