From: "Gerb Stralko" <gerb.stralko@gmail.com>
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Date: Sun, 1 Jun 2008 20:45:38 -0400
Message-ID: <75b57c110806011745t1af46305mddaf01f8c321857f@mail.gmail.com>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
	 <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
	 <1212069932.3428.1.camel@localhost.localdomain>
	 <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
	 <1212072912.3428.28.camel@localhost.localdomain>
	 <75b57c110805290804p2280a6ffwf68174754db59e9c@mail.gmail.com>
	 <1212074573.3428.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:60537 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFBApk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jun 2008 20:45:40 -0400
Received: by wx-out-0506.google.com with SMTP id h29so515702wxd.4
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jun 2008 17:45:38 -0700 (PDT)
In-Reply-To: <1212074573.3428.32.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, May 29, 2008 at 11:22 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2008-05-29 at 11:04 -0400, Gerb Stralko wrote:
>> On Thu, May 29, 2008 at 10:55 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Thu, 2008-05-29 at 10:35 -0400, Gerb Stralko wrote:
>> >> So is that printk really needed?  Should the kernel even need to print
>> >> a message like that, esp. if user-space is handling state updates and
>> >> notifications.  Or do i need to configure hald to be quietier?   FWIW
>> >> I'm using fedora core 9 and hald version:
>> >> -bash-3.2$ /usr/sbin/hald --version
>> >> HAL package version: 0.5.11
>> >
>> > Actually, I misspoke; it's set internally via sets of ioctls.  However,
>> > it's designed only to show on ioctls that do medium requiring things.
>> >
>> > I'm also using FC9 and I see no such messages (and for noisy cgc,
>> > they're printed out for every action on the CD).  You have some
>> > application that's poking the CD wrongly (probably not hal), so you
>> > really need to find out what it is.  It may be pointing to some other
>> > error in the kernel that needs fixing, but simply removing the message
>> > is covering up the issue.
>> >
>> > To help track the application, you could update the printk to print out
>> > current->comm and current->pid.  That would tell you who is responsible
>> >
>> > James
>> >
>> >
>> >
>> Okay, i'll do some investigation and see if I can track this down,
>> I'll let you know.   Thanks for the info.
>>
>> Are you using GNOME or KDE?  I'm currently using KDE.
>
> I'm using gnome ... there are intermittent reports of kde problems
> mainly with k3b though (the burner program), but if you put the printk
> in it should identify the application.
>
> James
>
>
>
I download the fedora updates and I rebooted and the messages went
away from my dmesg.   I left my computer on for a few hours and no
message. So I guess I problem was fixed in one of the updates.

Thanks for you help.  Sorry for the noise.

thanks again,

Jerry
