From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] target: Return descriptor format sense data
Date: Tue, 14 Jul 2015 04:21:04 -0400
Message-ID: <yq1r3obrvyn.fsf@sermon.lab.mkp.net>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
	<1436697423-20611-4-git-send-email-sagig@mellanox.com>
	<20150714071703.GC31117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150714071703.GC31117@infradead.org> (Christoph Hellwig's
	message of "Tue, 14 Jul 2015 00:17:03 -0700")
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> I think this needs to be a tunable as old initiators might
Christoph> not be able to cope with descriptor sense data.  My idea was
Christoph> to only turn it own if the LU is large enough to need it.

We could make it conditional and only use the descriptor format if the
LBA is big enough to warrant it.

-- 
Martin K. Petersen	Oracle Linux Engineering
