From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Sun, 22 Feb 2015 08:29:31 -0800
Message-ID: <20150222162931.GA9379@infradead.org>
References: <54B63F74.2040702@sandisk.com>
 <20150115090829.GA14154@infradead.org>
 <54B7E70C.8020304@sandisk.com>
 <20150119092153.GA8666@infradead.org>
 <54BCD00D.4080603@sandisk.com>
 <54E7112F.2080901@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E7112F.2080901@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 20, 2015 at 11:49:19AM +0100, Bart Van Assche wrote:
> Hello Christoph,
> 
> What I proposed myself consists of three steps:
> 1. Updating the LIO SRP target driver to a more recent version.
> 2. Target driver and LIO core refactoring such that the LIO and
>    SCST APIs can be unified.
> 3. Adding support in SCST for the unified target driver API.
> 
> This work is taking a little more time than I had expected - I still
> have to start with step (3). But I can already show in which direction I
> would like to go for steps (1) and (2). The 43 patches I came up with so
> far for steps (1) and (2) are available in the lio branch of the
> https://github.com/bvanassche/linux git repository. As you can see in
> that repository 42 of these 43 patches make sense even without knowing
> that something like SCST exists.

The work in there looks really good and easily mergeable with a few
mostly cosmetic comments.

I still don't see the point of adding this to LSF, we have far more
important and wide ranging topics then cleaning up some target
internals.
