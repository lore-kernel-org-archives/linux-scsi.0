From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: mpt2sas logged messages
Date: Thu, 20 Aug 2009 11:18:01 -0400
Message-ID: <4A8D6929.7000407@redhat.com>
References: <4A8AAA26.9090706@redhat.com> <20090818132518.GA4418@kroah.com> 	<4A8AB3DC.4060805@redhat.com> <20090818145710.GA6064@kroah.com> 	<4A8ACE7C.5080501@redhat.com> <20090818164017.GA24305@kroah.com> 	<ac3eb2510908181137ne79d4d7he1731d240bca614c@mail.gmail.com> 	<4A8AF5E4.7000806@redhat.com> <ac3eb2510908191230r7687ba34k4b8f6987ffa97ab8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZHTPSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 11:18:02 -0400
In-Reply-To: <ac3eb2510908191230r7687ba34k4b8f6987ffa97ab8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tom Coughlan <coughlan@redhat.com>

On 08/19/2009 03:30 PM, Kay Sievers wrote:
> On Tue, Aug 18, 2009 at 20:41, Ric Wheeler<rwheeler@redhat.com>  wrote:
>
>> I think that we can reconfigure the storage to avoid this but will be happy
>> to restore this configuration if you have something that you want to test
>> later on...
>
> This hopefully addresses the issue:
>    http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=2ffc9cc1917b1bb6fe86881a94a47dce9aa15168
>
> Thanks,
> Kay

Hi Kay,

This seems to resolve the issue on my test rig - no more "too long" error 
messages during boot.

Many thanks!

Ric

