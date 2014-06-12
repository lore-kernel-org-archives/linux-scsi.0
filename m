From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/14] block: Relocate integrity flags
Date: Wed, 11 Jun 2014 21:51:52 -0400
Message-ID: <yq1d2eerj2f.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-10-git-send-email-martin.petersen@oracle.com>
	<20140611165147.GD9511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45464 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLBwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 21:52:22 -0400
In-Reply-To: <20140611165147.GD9511@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:51:47 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Wed, May 28, 2014 at 11:28:43PM -0400, Martin K. Petersen wrote:
>> Move flags affecting the integrity code out of the bio bi_flags and
>> into the block integrity payload.

Christoph> It seems like bip is guaranteed to be non-NULL in all callers
Christoph> of the getters and setters.

Yeah, check removed.

Christoph> I'd recommend just dropping them and opencode the flags
Christoph> manipulation.

The reason I don't use test_bit() and set_bit() is that bip_flags is
just a short. And to-shift-or-not-to-shift is a crappy, error prone
interface, IMHO.

-- 
Martin K. Petersen	Oracle Linux Engineering
