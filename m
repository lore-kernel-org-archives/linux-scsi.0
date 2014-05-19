From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi error handling thread and REQUEST SENSE
Date: Mon, 19 May 2014 13:26:21 +0200
Message-ID: <5379EA5D.2040700@acm.org>
References: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net> <1400270713.3813.33.camel@localhost.localdomain> <5379C1B2.2040600@suse.de> <5379DD04.9020303@acm.org> <5379DEF4.9000301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:38684 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaESL0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 07:26:23 -0400
In-Reply-To: <5379DEF4.9000301@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, emilne@redhat.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/19/14 12:37, Hannes Reinecke wrote:
> Plus this is just a test patch, nothing official yet.
> I'm happy to include the changes for SRP if you can confirm that SRP
> requires autosense.

Hello Hannes,

Since the SRP protocol supports returning sense data in the SRP response
message and since every SRP target system I'm familiar with supports
command queueing I think it is safe to enable the autosense feature in
the SRP initiator driver.

Bart.
