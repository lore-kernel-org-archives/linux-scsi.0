From: Alexander Jolk <alexj@buf.com>
Subject: Re: LSI MegaRAID SATA 300-X8 problems
Date: Tue, 12 Jul 2005 16:52:49 +0200
Message-ID: <42D3D941.6030109@buf.com>
References: <42A5F235.6000300@buf.fr> <42A601E0.8090404@buf.fr>	 <42A85F96.5080608@buf.fr> <1121179247.8199.3.camel@driver>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.buf.fr ([195.68.52.65]:42184 "EHLO mail.buf.fr")
	by vger.kernel.org with ESMTP id S261493AbVGLOw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 10:52:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kallol@nucleodyne.com
Cc: Alexander Jolk <alexj@buf.fr>, linux-scsi@vger.kernel.org

Kallol Biswas wrote:
> Hello Alexander,
>                Could you get the LSI MegaRAID SATA 300-8X controller
> working for a long duration?
> 
> Have you run any performance benchmark on it yet? How much bandwidth do
> you get with the controller?

With a 2.6.11.11 kernel, I had it working for a few days finally before 
giving up.  I don't quite remember what bandwidth I got; since I didn't 
get any echo neither from LSI Logic nor on the mailing list, I've 
switched to 3ware controllers with software RAID since, getting 400MB/s 
sustained.

Alex




-- 
Alexander Jolk         /         BUF Compagnie
tel +33-1 42 68 18 28 /  fax +33-1 42 68 18 29

