From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Sun, 31 Aug 2008 20:18:24 +0200
Message-ID: <e2e108260808311118v3f8b60a2se0fbe58d476460e9@mail.gmail.com>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu>
	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
	 <48B59556.7050108@vlnb.net>
	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
	 <48B6E5C8.2000306@vlnb.net>
	 <1219964919.13470.505.camel@haakon2.linux-iscsi.org>
	 <48B823C4.7010803@vlnb.net>
	 <1220040606.13470.585.camel@haakon2.linux-iscsi.org>
	 <48B9B33C.2060106@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:3524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYHaSS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2008 14:18:26 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1057090fgg.17
        for <linux-scsi@vger.kernel.org>; Sun, 31 Aug 2008 11:18:24 -0700 (PDT)
In-Reply-To: <48B9B33C.2060106@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jerome Martin <tramjoe.merin@gmail.com>

On Sat, Aug 30, 2008 at 10:53 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> What would be if a program, who taken that mutex get dead before releasing
> it? You wouldn't receive a notification about its death, although with
> IOCTL's you would receive it. Will you invent a motex revoking mechanism for
> that.

Any mutex that has been locked by kernel code should be unlocked
before control is given back to userspace. Making kernel mutexes
visible to userspace would be very bad design.

Bart.
