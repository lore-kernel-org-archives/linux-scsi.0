From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 7/7] scsi_error: do not use command list for host reset
Date: Fri, 27 Jun 2014 09:06:15 +0200
Message-ID: <53AD17E7.8080002@acm.org>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:38679 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaF0HG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 03:06:29 -0400
In-Reply-To: <1403850425-89297-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/27/14 08:27, Hannes Reinecke wrote:
>   * scsi_eh_host_reset - send a host reset
> + * @shost:	&scsi host being recovered.

In "Documentation/kernel-doc-nano-HOWTO.txt" I found "'&struct_name' -
name of a structure (up to two words including 'struct')". This made me
wonder whether the ampersand was added on purpose in the
scsi_eh_host_reset() kernel-doc header ?

Bart.
