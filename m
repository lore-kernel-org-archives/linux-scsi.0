From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR/SCST 0.9.3-pre1 published
Date: Thu, 08 Sep 2005 00:07:13 +0400
Message-ID: <431F4871.6080905@vlnb.net>
References: <20050906212801.GB14057@cs.umn.edu> <20050907104932.GA14200@lst.de> <20050907124504.GA13614@cs.umn.edu> <431F35D2.7040209@vlnb.net> <431F37E6.3080706@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.infobox.ru ([195.208.235.29]:22150 "EHLO
	relay02.infobox.ru") by vger.kernel.org with ESMTP id S1751297AbVIGUI6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 16:08:58 -0400
In-Reply-To: <431F37E6.3080706@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: boutcher@cs.umn.edu, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxiep@us.ibm.com>, iscsitarget-devel@lists.sourceforge.net

Mike Christie wrote:
> Vladislav Bolkhovitin wrote:
>> Sorry, I can see on stgt page only mail lists archive and not from 
>> start (from Aug 22). Mike, can I see stgt code and some design 
>> description, please? You can send it directly on my e-mail address, if 
>> necessary.
> 
> goto the svn page for the code
> http://developer.berlios.de/svn/?group_id=4492
> 
> As for design desc, I do not have anything. It is the evolving source :) 
> We are slowly merging leasons we learned from open-iscsi, your SCST 
> code, the available software and HW targets, and the SCSI ULD's 
> scatterlist code which needs redoing so it is a bit of a mess.

OK, thanks, will try tomorrow.

I put SCST 0.9.3-pre1 on its page 
(http://sourceforge.net/projects/scst/). This is not the latest, but 
this is the one, which working. At the end of this week I'll try to put 
there the latest one as well. Hope, you will learn some more lessons 
from it :).

Any comments are welcome.

Vlad

