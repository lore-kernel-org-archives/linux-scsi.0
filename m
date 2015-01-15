From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 15 Jan 2015 01:08:29 -0800
Message-ID: <20150115090829.GA14154@infradead.org>
References: <54B63F74.2040702@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54B63F74.2040702@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I don't quite understand whay you're proposing.  We're obbiously not
adding hooks for out of tree code to the kernel.  If you can improve
the target core <-> driver interface (and there's plenty of opportunity
for improvement) and it also happens to help your cause it's all fine

But all that really is a matter of sending patches, and not some out
of the blue discussion.
