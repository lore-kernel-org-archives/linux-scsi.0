From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] scsi: fix timer setup in fas216.c
Date: Thu, 18 Feb 2010 16:40:53 +0000
Message-ID: <20100218164053.GE20243@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1002181058140.4373@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37614 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab0BRQlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2010 11:41:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002181058140.4373@axis700.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Thu, Feb 18, 2010 at 11:02:01AM +0100, Guennadi Liakhovetski wrote:
> mod_timer() takes an absolute time and not a delay as its argument.

Looks entirely valid, and has been around for a while.

I'll take it via the ARM tree, so please submit to the ARM patch system
with a 'CC: <stable@kernel.org>' attributation to allow stable folk to
pick up on it.

Thanks.
