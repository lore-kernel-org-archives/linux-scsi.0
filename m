From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Sat, 28 Jun 2003 11:08:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFDAF74.3030301@pobox.com>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org> <20030627190434.A10771@infradead.org> <20030627192321.GA3338@beaverton.ibm.com> <20030628093403.A8591@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:24290 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265252AbTF1Oyd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2003 10:54:33 -0400
In-Reply-To: <20030628093403.A8591@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

The future netdev api could be summarized as

	alloc_<foo>dev -- allocate structure, init
	register_netdev[ice] -- register
	unregister_netdev[ice] -- unregister
	release_netdev -- unref

We actually have this now, once you do s/kfree(dev)/release_netdev(dev)/

	Jeff


