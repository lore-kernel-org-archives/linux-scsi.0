From: "berthiaume, wayne" <wayne.berthiaume@emc.com>
Subject: RE: status of block-integrity
Date: Tue, 31 Dec 2013 14:41:35 -0500
Message-ID: <7B999F046DA9D54B825BD537939A3E2F023284EC69@MX23A.corp.emc.com>
References: <20131222192128.GA28532@infradead.org>
 <yq11u134rmt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq11u134rmt.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

You can add there are SCSI targets out there employing this feature as well. =;^)

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Martin K. Petersen
Sent: Monday, December 23, 2013 8:35 AM
To: Christoph Hellwig
Cc: Jens Axboe; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: status of block-integrity

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> We have the block integrity code to support DIF/DIX in the 
Christoph> the tree for about 5 and a half years, and we still don't 
Christoph> have a single consumer of it.

What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp) then integrity protection is active from the block layer down. The only code that's not currently being exercised are the tag interleaving functions.  I was hoping the FS people would use them for back pointers but nobody seemed to bite.


Christoph> Given that we'll have a lot of work to do in this area with 
Christoph> block multiqueue I think it's time to either kill it off for 
Christoph> good or make sure we can actually use and test it.

I don't understand why multiqueue would require a lot of work? It's just an extra scatterlist per request.

And obviously, if there's anything that needs to be done in this area I'll be happy to do so...

-- 
Martin K. Petersen	Oracle Linux Engineering

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
