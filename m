From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Sun, 02 Mar 2014 09:36:34 +0100
Message-ID: <5312ED92.20806@acm.org>
References: <1392287281-75002-1-git-send-email-hare@suse.de> <1392287281-75002-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:57439 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaCBIgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Mar 2014 03:36:38 -0500
In-Reply-To: <1392287281-75002-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 02/13/14 11:28, Hannes Reinecke wrote:
> -	return 0;
> +	return (buffer[2] << 8) + buffer[3] + 4;

Has it been considered to use get_unaligned_be16() instead of open
coding this function ?

Bart.

