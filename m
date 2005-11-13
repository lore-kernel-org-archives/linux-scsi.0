From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/4] scsi: remove usage of proc_name from scsi_host_alloc
Date: Sun, 13 Nov 2005 17:52:13 +0100
Message-ID: <43776F3D.4060205@s5r6.in-berlin.de>
References: <200511131619.jADGJFwQ032002@einhorn.in-berlin.de> <20051113164222.GA9308@infradead.org> <43776EA3.3010607@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36314 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964937AbVKMQyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:54:37 -0500
In-Reply-To: <43776EA3.3010607@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

I wrote:
> Christoph Hellwig wrote:
>> ->name is not mandatory.  You may just implement ->info
> 
> No, ->info is optional according to a current comment, and according to 
> the implementation as far as I have seen.
> 
> Also, ->name is used in a number of places if some other host template 
> members are not provided, i.e. it is practically mandatory.

PS: name can be (and is) used in place of info, but info can hardly be 
used instead of name because name is shorter.
-- 
Stefan Richter
-=====-=-=-= =-== -==-=
http://arcgraph.de/sr/
