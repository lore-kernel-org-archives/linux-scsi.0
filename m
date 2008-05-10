From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: lsscsi is broken
Date: Sat, 10 May 2008 16:01:57 -0700
Message-ID: <86802c440805101601h8591418t3d728e61ea4a1332@mail.gmail.com>
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
	 <4825EAA0.5030305@torque.net>
	 <86802c440805101306w64b5c72dn4dbfea74a6557c2f@mail.gmail.com>
	 <20080510211904.GN19219@parisc-linux.org>
	 <86802c440805101522l3cec5089he5d077fdee698cea@mail.gmail.com>
	 <20080510223643.GO19219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:47796 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbYEJXB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 May 2008 19:01:58 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2113805rvb.1
        for <linux-scsi@vger.kernel.org>; Sat, 10 May 2008 16:01:58 -0700 (PDT)
In-Reply-To: <20080510223643.GO19219@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Sat, May 10, 2008 at 3:36 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, May 10, 2008 at 03:22:31PM -0700, Yinghai Lu wrote:
>> will look at it monday or later.
>>
>> don't want to keep on booting my laptop.
>>
>> or my .config has some setting problem? it could be duplicated on all
>> my test servers
>
> Could be "# CONFIG_SYSFS_DEPRECATED is not set".  I have no idea what
> that controls, but /sys/bus/scsi/devices could be one thing.
>
looked at last config for 2.6.25, the SYSFS setting in CONFIG is the
same as the one for current git.

YH
