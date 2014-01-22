From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP passthrough
 support
Date: Wed, 22 Jan 2014 12:09:14 +0200
Message-ID: <52DF98CA.3000300@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>	<1390099480-29013-12-git-send-email-nab@daterainc.com>	<52DBC32C.4060505@dev.mellanox.co.il> <yq1fvogbx5a.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1fvogbx5a.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/22/2014 3:52 AM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
> Sagi> Please remind me why we ignore IP-CSUM guard type again?  MKP,
> Sagi> will this be irrelevant for the initiator as well? if so, I don't
> Sagi> see a reason to expose this in RDMA verbs.
>
> I don't see much use for IP checksum for the target. You are required by
> SBC to use T10 CRC on the wire so there is no point in converting to IP
> checksum in the backend.
>
> My impending patches will allow you to pass through PI with T10 CRC to a
> device with an IP checksum block integrity profile (i.e. the choice of
> checksum is a per-bio bip flag instead of an HBA-enforced global).
>

OK, so IP checksum support still makes sense.

Thanks!

Sagi.
