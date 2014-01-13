From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
Date: Mon, 13 Jan 2014 15:30:12 -0500
Message-ID: <yq138kroca3.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-10-git-send-email-nab@daterainc.com>
	<yq161prr1p8.fsf@sermon.lab.mkp.net>
	<1389637859.5567.431.camel@haakon3.risingtidesystems.com>
	<1389639177.12062.21.camel@dabdike.int.hansenpartnership.com>
	<1389641243.5567.445.camel@haakon3.risingtidesystems.com>
	<yq1a9ezocrg.fsf@sermon.lab.mkp.net>
	<1389644643.12062.42.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389644643.12062.42.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Mon, 13 Jan 2014 12:24:03 -0800")
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> I'm intrigued by this: how do you get the extra space, since I
James> heard all the drive vendors were adamant that 520 was it for the
James> current manufacturing processes.

Well, you've been able to get 528-byte sector drives for a long
time. They are used inside arrays that use both PI and internal
metadata.

In any case Type 4 was never intended for 512-byte sectors. The existing
16-bit T10 CRC is pretty useless for 4096-byte blocks so the proposal
was aimed at 4096+16 (but obviously that tidbit is outside of the T10
spec that doesn't mandate block sizes or accompanying PI types).

-- 
Martin K. Petersen	Oracle Linux Engineering
