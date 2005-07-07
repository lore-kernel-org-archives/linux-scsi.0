From: Christoph Hellwig <hch@infradead.org>
Subject: Re: is there going to be aic7xxx driver update
Date: Thu, 7 Jul 2005 13:53:02 +0100
Message-ID: <20050707125302.GA28489@infradead.org>
References: <0882D625EC1D3043B8F0C4C3C8F73451016FC286@ntmail.gsf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12733 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261436AbVGGMxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2005 08:53:09 -0400
Content-Disposition: inline
In-Reply-To: <0882D625EC1D3043B8F0C4C3C8F73451016FC286@ntmail.gsf.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bhanu, Yogesh" <yogesh@gsf.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2005 at 03:29:49PM +0200, Bhanu, Yogesh wrote:
> Hi ,
>      It is continuation to my last post regarding aic7xxx driver flaking load.
> I really think this is a driver issue as I have switched several 39160 cards
> all showing same result . 
> I have seen adaptec has released newer drivers . But unfortunately the dont go
> well with the latest 2.6 kernels has  anybody found a fix to the probelem .

The adaptec drivers are a total mess and contain various regression vs whats
in mainline.  I'd suggest you report the problems you have with the latest
mainline driver to this list in detail so it can be fixed.

