From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] sd: dynamically adjust SD_MAX_WS16_BLOCKS as per the actual logical block size
Date: Tue, 16 Aug 2016 00:02:52 -0400
Message-ID: <yq1k2fhl5sj.fsf@sermon.lab.mkp.net>
References: <b7f44789e0e68fa57d2e3cd059ac3a5bc6d53495.1470954520.git.tom.ty89@gmail.com>
	<yq1bn0yptqq.fsf@sermon.lab.mkp.net>
	<CAGnHSEk1UG1CaX+2zv20ONxnM7XavGvW9kX2KSPy7R7ZoKL_pA@mail.gmail.com>
	<yq1shu9n37h.fsf@sermon.lab.mkp.net>
	<CAGnHSEmh7ckOksN3T64nLtTax0aaQYN67h+j-YwYwBw3ihTf6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEmh7ckOksN3T64nLtTax0aaQYN67h+j-YwYwBw3ihTf6A@mail.gmail.com>
	(Tom Yan's message of "Sun, 14 Aug 2016 16:46:00 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun@tancheff.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

>> 0x7fffff, the maximum number of block layer sectors that can be
>> expressed in a single bio.

Tom> Hmm, so when we queue any of the limits, we convert a certain
Tom> maximum number of physical sectors (which we has already been
Tom> doing)

logical sectors

Tom> to its corresponding maximum number of block layer sectors, and
Tom> then make sure that number does not exceed 0x7fffff, right?

Yep.

-- 
Martin K. Petersen	Oracle Linux Engineering
