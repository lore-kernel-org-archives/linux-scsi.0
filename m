From: Paul Bolle <pebolle@tiscali.nl>
Subject: scsi: SCSI_FC_TGT_ATTRS
Date: Mon, 14 Jul 2014 10:29:04 +0200
Message-ID: <1405326544.8281.17.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58048 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaGNIeO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 04:34:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

0) Commit 73685a458f2e ("tgt: removal") landed in next-20140714. It
states that "the CONFIG_SCSI_TGT, CONFIG_SCSI_SRP_TGT_ATTRS and
CONFIG_SCSI_FC_TGT_ATTRS kbuild variable[s] [...] are no longer needed".
It removed the Kconfig entry for SCSI_SRP_TGT_ATTRS, but it left the
entries for SCSI_TGT and SCSI_FC_TGT_ATTRS untouched.

1) Both SCSI_TGT and SCSI_FC_TGT_ATTRS appear to be unused after that
commit. Is a patch to remove their Kconfig entries queued somewhere?


Paul Bolle

