From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] target: Use scsi helpers to build the sense data
 correctly
Date: Mon, 6 Jul 2015 02:06:54 -0700
Message-ID: <20150706090654.GC15996@infradead.org>
References: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
 <1436169747-28834-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47853 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbGFJGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2015 05:06:55 -0400
Content-Disposition: inline
In-Reply-To: <1436169747-28834-4-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On Mon, Jul 06, 2015 at 11:02:27AM +0300, Sagi Grimberg wrote:
> Instead of open coding the sense buffer construction, use
> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
> helpers which moved to scsi_common.
> 
> This patch also fixes wrong setting of descriptor format sense data
> for t10-pi integrity errors.

Please split this into three patches:

 1) move the helpers to scsi_common.c
 2) use helpers in the target code
 3) always use descriptor-type sense data for PI errors

