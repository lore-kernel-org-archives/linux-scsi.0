From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP passthrough support
Date: Tue, 21 Jan 2014 20:54:14 -0500
Message-ID: <yq1bnz4bx2x.fsf@sermon.lab.mkp.net>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	<1390099480-29013-12-git-send-email-nab@daterainc.com>
	<52DBC32C.4060505@dev.mellanox.co.il>
	<1390342817.5567.778.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390342817.5567.778.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Tue, 21 Jan 2014 14:20:17 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> Please remind me why we ignore IP-CSUM guard type again?  MKP, will
>> this be irrelevant for the initiator as well? if so, I don't see a
>> reason to expose this in RDMA verbs.

nab> My understanding is that this was used for pre-production
nab> prototyping, and is not supported by any real backend storage
nab> hardware.

We are shipping several products with support for the IP checksum. But
it's between application and initiator only. From there on it's all T10
CRC as required by the spec.

-- 
Martin K. Petersen	Oracle Linux Engineering
