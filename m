From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 11:46:58 -0400
Message-ID: <4874DD72.2050903@garzik.org>
References: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <20080709154753.3dcfacab@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37430 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbYGIPrX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 11:47:23 -0400
In-Reply-To: <20080709154753.3dcfacab@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Cox wrote:
> On Wed, 09 Jul 2008 12:35:47 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
>> Mark i2o config broken on 64-bit platforms as it generates these:
>>
>> In file included from drivers/message/i2o/config-osm.c:39:
>> drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
>> drivers/message/i2o/i2o_config.c:889: warning: cast to pointer from integer of different size
>> drivers/message/i2o/i2o_config.c:945: warning: cast to pointer from integer of different size
>>
>> which are apparently non-trivial to fix (eg: inserting a cast through unsigned
>> long is not correct according to Linus).  This would be due to struct
>> sg_simple_element only having a 32-bit addr_bus value.
>>
>> There are also a number of "TODO 64bit fix" comments.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
> 
> 
> NAK - it appears to be broken for 64bit user space only

Agreed.

That was the conclusion when I joined the cast of thousands who tried to 
kill this warning, and found that out...

	Jeff




