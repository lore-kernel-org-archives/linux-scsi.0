From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Wed, 14 Oct 2015 17:34:11 +0000
Message-ID: <20151014173411.998738f6gjjvzf2r@imap.suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
 <1444833036.2220.38.camel@HansenPartnership.com>
 <1444833547.19542.21.camel@suse.de> <20151014161238.GA31708@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151014161238.GA31708@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Zitat von Christoph Hellwig <hch@infradead.org>:

> On Wed, Oct 14, 2015 at 04:39:07PM +0200, Johannes Thumshirn wrote:
>> removal. This is what my initial proposal did as well. Christoph wanted
>> me to decouple the whole process from the host_lock though and this is
>> what this patches do as well now.
>
> I think we've talked past each other, I didn't intend to say that and
> my replies to you don't seem to imply that either.

OK, I think I misunderstood you then.

>
> I'll draft a patch for what I meant.
>
