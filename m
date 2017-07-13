From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC v3 1/2] scsi: generate uevent for SCSI sense code
Date: Thu, 13 Jul 2017 08:39:57 +0200
Message-ID: <20170713063957.GA5212@linux-x5ow.site>
References: <20170712223535.2609814-1-songliubraving@fb.com>
 <20170712223535.2609814-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750748AbdGMGkC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Jul 2017 02:40:02 -0400
Content-Disposition: inline
In-Reply-To: <20170712223535.2609814-2-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com, emilne@redhat.com

On Wed, Jul 12, 2017 at 03:35:34PM -0700, Song Liu wrote:
> +	if (!test_bit(sshdr->sense_key & 0xf,
> +		      &sdev->sense_event_filter))

While being technically correct, this looks a bit kludgy. Please pass
in the whole sense_key without masking it.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
