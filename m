From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] kill tmscsim ->proc_info
Date: Tue, 17 Aug 2004 22:38:09 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408172233590.5224@poirot.grange>
References: <20040817161858.GA16589@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:27836 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268473AbUHQVyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 17:54:04 -0400
In-Reply-To: <20040817161858.GA16589@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2004, Christoph Hellwig wrote:

> hrrible code like all proc_info implementations and no really usefull
> information.  We might want to add sysfs attributes if some users really
> miss anything.

Well, I don't have a strong opinion on this one. I tend to believe you, 
Christoph, and I am sure James will take a wise decision:-) I might agree, 
that the code is ugly, but there was already at least 1 complaint:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

