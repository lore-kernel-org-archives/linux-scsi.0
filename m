From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Thu, 28 Aug 2008 21:52:42 +0400
Message-ID: <48B6E5EA.9040309@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>	 <48B59556.7050108@vlnb.net>	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org> <1219876840.13470.402.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:51428 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754523AbYH1RwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 13:52:13 -0400
In-Reply-To: <1219876840.13470.402.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>, Ming Zhang <blackmagic02881@gmail.com>

Nicholas A. Bellinger wrote:
>>> Thus, I would suggest that before making the further move we should also 
>>> consider configuration interfaces of SCST and LIO and choose the best 
>>> things from all 3.
>>>
>> So, Ming mentioned configfs for this...  /me reads about configfs
>>
> 
> Ah yes, I remember now, this is part of the OCFS2 patchset and it uses
> it for /config/cluster/ocfs2/[heartbeat,node] information, as well as
> other tunables related to millisecond timeout values.  These are
> basically the values from /etc/ocfs2/cluster.conf..
> 
> Looking at http://lwn.net/Articles/148973/, this looks like a strong
> contender for what we would require with a generic kernel level target
> engine.

For our task I don't think configfs has any advantage over sysfs.

Vlad
