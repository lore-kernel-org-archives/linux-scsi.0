From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
Date: Fri, 10 Jan 2014 16:06:28 -0500
Message-ID: <yq11u0fr1gr.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-14-git-send-email-nab@daterainc.com>
	<52CE7ABA.9080403@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52CE7ABA.9080403@mellanox.com> (Sagi Grimberg's message of "Thu,
	9 Jan 2014 12:32:26 +0200")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> I wander how we can skip sbc_dif_verify_xxxx if the transport
Sagi> already offloaded DIF verify.  I think that the transport should
Sagi> signal the core layer that it is able to offload DIF
Sagi> (ADD/STRIP/PASS/VERIFY), in which case the core should turn off
Sagi> the backstore DIF verify emulation to sustain performance.

Yeah, for SAS and FC it would be nice to leverage DIX and let the ASIC
do the actual checking and splitting. I assume the same is true for your
hw.

-- 
Martin K. Petersen	Oracle Linux Engineering
