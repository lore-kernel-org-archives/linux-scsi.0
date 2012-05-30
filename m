From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH] scsi: fix hot unplug vs async scan race
Date: Wed, 30 May 2012 13:20:32 -0500
Message-ID: <4FC664F0.10805@cs.wisc.edu>
References: <20120525075352.27883.81838.stgit@dwillia2-linux.jf.intel.com> <CAA9_cme9j7n726kOxOupJLd4Tajjic8QwLA_LXk21B7YEH15BA@mail.gmail.com> <4FC06185.10003@cs.wisc.edu> <CAA9_cmeuPNHQmOASVMC_9pULSJ+HXkRdYKM57GvYTQUTQE4H4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37043 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263Ab2E3SUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 14:20:47 -0400
In-Reply-To: <CAA9_cmeuPNHQmOASVMC_9pULSJ+HXkRdYKM57GvYTQUTQE4H4A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Robert Love <robert.w.love@intel.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>, Matthew Wilcox <matthew@wil.cx>, Dariusz Majchrzak <dariusz.majchrzak@intel.com>

On 05/29/2012 07:48 PM, Dan Williams wrote:
>> for each device
>>        echo 1 > /sys/..../remove
>>
>> then the target would get reaped/freed from under the transport class right?
> 
> Where does that 'remove' attribute come from?  I can't seem to find it.
> 

Oops. I meant delete. /sys/block/sdX/device/delete. There is also the
proc delete file too.
