From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support
 using libcrypto
Date: Sat, 23 Jul 2011 20:39:33 +0400
Message-ID: <1311439173.23720.14.camel@mulgrave>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55581 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab1GWQjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2011 12:39:41 -0400
In-Reply-To: <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, 2011-07-23 at 08:45 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds support for libcrypto md5 based iSCSI CHAP authentication
> support for iscsi_target_mod.  This includes support for mutual and one-way
> NodeACL authentication for SessionType=Normal and SessionType=Discovery
> via /sys/kernel/config/target/iscsi.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c |  490 ++++++++++++++++++++++++++++++
>  drivers/target/iscsi/iscsi_target_auth.h |   31 ++
>  2 files changed, 521 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/iscsi/iscsi_target_auth.c
>  create mode 100644 drivers/target/iscsi/iscsi_target_auth.h

I've asked you twice for input on the patch doing this in userspace,
which was posted five weeks ago.  Just ignoring something is
unacceptable behaviour ... what do I have to do to get your attention?
NAK the patch set?

James


