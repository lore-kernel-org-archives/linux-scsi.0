From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/3] g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio
Date: Sun, 25 Sep 2016 17:49:41 -0700
Message-ID: <20160926004940.GB32302@infradead.org>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org>
 <1474832360-23261-1-git-send-email-linux@rainbow-software.org>
 <20160925235542.GD7312@infradead.org>
 <alpine.LNX.2.00.1609261034480.13676@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1609261034480.13676@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2016 at 10:37:13AM +1000, Finn Thain wrote:
> Let's not do that yet. I have a patch series that fixes the type casting 
> and related issues that I will post soon. I expect that Ondrej's patches 
> will be ready before mine are, so I'll rebase mine on this work before I 
> ask him to test my patches.

Ok, even better.
