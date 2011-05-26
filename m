From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
 Parameter logic
Date: Thu, 26 May 2011 11:46:55 -0500
Message-ID: <1306428415.4048.22.camel@mulgrave.site>
References: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
	 <1305862678-30150-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42571 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347Ab1EZQq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2011 12:46:59 -0400
In-Reply-To: <1305862678-30150-8-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>

On Thu, 2011-05-19 at 20:37 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds the princple RFC-3720 compatiable iSCSI Login
> phase negotiation for iscsi_target_mod.  This also includes the
> target RX/TX thread queue logic which is called directly from iSCSI
> login associated code.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org> 

I thought the upshot of the thread with Tomo was that we wouldn't be
doing all of this in-kernel.  Where's the userspace upcall for this?

James


