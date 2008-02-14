From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
Date: Thu, 14 Feb 2008 16:59:03 -0500
Message-ID: <47B4B9A7.4080304@garzik.org>
References: <20080212234928.GA13892@havoc.gtf.org> <47B2CF57.9030308@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58742 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYBNV7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 16:59:05 -0500
In-Reply-To: <47B2CF57.9030308@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Boaz Harrosh wrote:
> do you intend this to be pushed into 2.6.25-rcx or this is already
> for 2.6.26? Should we put this in -mm tree for testing?


Not intended for 2.6.25.  I just wanted to get this "in process" 
somewhere, and keep this issue moving.  I would definitely prefer to 
have this tested before it goes to Linus.

Its a long term goal to kill pci_find_device(), and this conversion was 
a side effect of that.

	Jeff



