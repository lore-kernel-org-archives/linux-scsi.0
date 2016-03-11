From: Christoph Hellwig <hch@infradead.org>
Subject: Re: QoS for iSCSI target?
Date: Thu, 10 Mar 2016 23:30:18 -0800
Message-ID: <20160311073018.GA23379@infradead.org>
References: <56E1F419.5070005@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E1F419.5070005@windriver.com>
Sender: target-devel-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 10, 2016 at 04:24:25PM -0600, Chris Friesen wrote:
> Hi,
> 
> I'm looking for information on whether the iSCSI target in the kernel offers
> any way to do QoS between traffic driven by different initiators.
> 
> I'm trying to make sure that one initiator can't do a denial-of-service
> attack against others.
> 
> Does the kernel target have this sort of thing built-in, or do I need to
> look at network traffic-shaping to achieve this?

It doesn't right now, but it shouldn't be hard to integrate it with
blk cgroups.
