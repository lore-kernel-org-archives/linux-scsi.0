From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SAS overview
Date: Sun, 28 Mar 2004 17:38:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406753E4.70007@pobox.com>
References: <20040328220632.ADD8D76C4F@isis.visi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46819 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262465AbUC1Wim
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Mar 2004 17:38:42 -0500
In-Reply-To: <20040328220632.ADD8D76C4F@isis.visi.com>
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: dougg@torque.net, Matthew Wilcox <willy@debian.org>, linux-scsi <linux-scsi@vger.kernel.org>

Scott M. Ferris wrote:
> For the fast path of queueing and completing commands, I'd expect SAS
> HBAs to work similar to SPI HBAs, where all the HBA driver does is
> queue commands with data buffers, and wait for an interrupt to
> indicate that one or more commands have completed.  For performance,
> the HBA needs to manage the entire lifetime of the command, and DMA
> data back and forth without needing intervention by the HBA driver.

Newer SATA controllers do this for you, but still give you low level 
access to the individual frames being sent on the SATA wire...

	Jeff



