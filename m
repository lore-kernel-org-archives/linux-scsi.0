From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information
 using handshake protocol only after HBA card gets into READY or Operational
 state
Date: Wed, 16 Jul 2014 00:06:51 -0700
Message-ID: <20140716070651.GA17886@infradead.org>
References: <20140625103532.GA12953@avagotech.com>
 <yq1wqbetsf2.fsf@sermon.lab.mkp.net>
 <CAK=zhgoWvnXFdGqVevWJmLpDebb0fq9euYjxJE+EEGYqLoPrhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgoWvnXFdGqVevWJmLpDebb0fq9euYjxJE+EEGYqLoPrhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 12:00:22PM +0530, Sreekanth Reddy wrote:
> Next time onwards I will follow as per your suggestions while posting the
> patches to upstream.

Btw, it would be good to resend the series with the various updates from
Martin once he's done with the review.  That makes it a lot easier for
me to pick it up.

If you want to make my life even easier send the series using
git-send-patch so that it's properly threaded.
