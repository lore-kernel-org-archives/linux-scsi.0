From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Multiple invocations of scsi_scan_host() on a given host...
Date: Fri, 16 Apr 2004 19:14:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408068D9.1040609@pobox.com>
References: <B179AE41C1147041AA1121F44614F0B060EE65@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:29063 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263947AbUDPXOq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 19:14:46 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EE65@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> 2) If multiple invocations of scsi_scan_host() are allowed for a given
> host, would a satisfactory fix be:


FWIW I would prefer that multiple invocations of scsi_scan_host() work.

I was planning to do so... :)

	Jeff



