From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Tue, 30 Dec 2014 12:32:06 +0100
Message-ID: <20141230113206.GA1461@lst.de>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de> <549FF2DB.4000506@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <549FF2DB.4000506@profihost.ag>
Sender: target-devel-owner@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 28, 2014 at 01:08:59PM +0100, Stefan Priebe wrote:
>> Nic, can you fix LIO to expose the proper max xfer size?
>
> some more problems while running this patch.
>
> My crucial m500 and m550 ssds (i have around 60 in 30 different cases and 
> motherboards but all attached as jbods at LSI HBAs) print those errors:

What is the max_sectors_kb value for them?
