From: Kallol Biswas <kallol@nucleodyne.com>
Subject: Re: LSI MegaRAID SATA 300-X8 problems
Date: 12 Jul 2005 08:28:10 -0700
Message-ID: <1121182089.8199.20.camel@driver>
References: <42A5F235.6000300@buf.fr> <42A601E0.8090404@buf.fr>
	 <42A85F96.5080608@buf.fr> <1121179247.8199.3.camel@driver>
	 <42D3D941.6030109@buf.com>
Reply-To: kallol@nucleodyne.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([216.148.227.89]:48012 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S261523AbVGLPat (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 11:30:49 -0400
In-Reply-To: <42D3D941.6030109@buf.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Jolk <alexj@buf.com>
Cc: Alexander Jolk <alexj@buf.fr>, linux-scsi@vger.kernel.org

The 3ware controller you used is a PCI 2.2 64/66Mhz 900 series
controller, right?

What is the theoretical limit with the adapter? 528MB/sec, right?

On Tue, 2005-07-12 at 07:52, Alexander Jolk wrote:
> Kallol Biswas wrote:
> > Hello Alexander,
> >                Could you get the LSI MegaRAID SATA 300-8X controller
> > working for a long duration?
> > 
> > Have you run any performance benchmark on it yet? How much bandwidth do
> > you get with the controller?
> 
> With a 2.6.11.11 kernel, I had it working for a few days finally before 
> giving up.  I don't quite remember what bandwidth I got; since I didn't 
> get any echo neither from LSI Logic nor on the mailing list, I've 
> switched to 3ware controllers with software RAID since, getting 400MB/s 
> sustained.
> 
> Alex
> 
> 
> 

