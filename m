From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ultrastor.c is a bit-rot
Date: Mon, 17 Mar 2008 16:07:39 +0000
Message-ID: <20080317160739.04ad0939@core>
References: <47DE8736.8020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751736AbYCQQYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 12:24:10 -0400
In-Reply-To: <47DE8736.8020405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

> if the machine has more then 2^24 of memory. Then this will never
> work, right? or I'm missing it completely?

It will work compiled in, and probably users of such cards if any don't
have > 16MB. I doubt anyone is using the driver however.

Alan
