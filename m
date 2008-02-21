From: Andrew Buehler <abuehler.kernel@gmail.com>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly	resolved
Date: Thu, 21 Feb 2008 14:43:17 -0500
Message-ID: <47BDD455.9090909@gmail.com>
References: <47BDA141.70806@gmail.com> <Pine.LNX.4.44L0.0802211134040.4528-100000@iolanthe.rowland.org> <20080221171726.GA30927@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:19427 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYBUTnW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2008 14:43:22 -0500
Received: by an-out-0708.google.com with SMTP id d31so41016and.103
        for <linux-scsi@vger.kernel.org>; Thu, 21 Feb 2008 11:43:21 -0800 (PST)
In-Reply-To: <20080221171726.GA30927@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Pinter <oliver.pntr@gmail.com>, Kernel development list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 2/21/2008 12:17 PM, Greg KH wrote:

> On Thu, Feb 21, 2008 at 11:36:23AM -0500, Alan Stern wrote:
> 
>> On Thu, 21 Feb 2008, Andrew Buehler wrote:

[Greg KH]
>>> I know he's in the CC:, but I'm not sure he's reading this
>>> thread, and I'm hesitant to bother people about things out of the
>>> blue unless I have reason to expect that it's something they're
>>> going to care about. (Just because it's a big deal for me doesn't
>>> mean it makes one whit of difference to anyone else, and from
>>> what little I've seen on linux-kernel he seems to be somewhat
>>> important and fairly busy...)
>> 
>> In this case you shouldn't worry about it.  I don't know whether
>> Greg has been following this thread either, but I do know that he
>> spends a lot of time and effort trying to improve vendors' support
>> for Linux. This is right up his alley.  What I'm not sure about is
>> the extent of his influence over Novell...
> 
> Heh, yes, I've been reading this.
> 
> It sounds like an old version of a Novell product is making a newer
> kernel spit out a warning message.

Originally that was all that it was, but now I am seeing the product in
question not even see the hard drive despite the fact that it is
mountable with standard utilities. Whether the failure is in the program
or elsewhere I don't know, but I'm hoping it's in the program, because
if it's elsewhere I have a *lot* of tedious digging and testing ahead of
me and little real idea of where to start.

> Odds are this is fixed in a newer one,

I haven't been able to find a newer version of the program, and do not
have the standing with my organization to contact Novell on their
behalf. (When I brought the idea up with the people who do have such
standing, in another context, the answer I received was essentially
"wait until we upgrade the servers to that version, which will not be
soon".) I also have not been able to find a clear contact path in any
case.

> as well as the basic issue that Novell doesn't even ship anything
> based on the 2.6.24 kernel yet, so perhaps the Zenworks developers
> don't even know of the issue, that's what bugzilla.novell.com is for
> :)

The problem has been present at least since 2.6.23.x and I think since
2.6.18, but from what I've been able to find Novell's last kernel was
based on 2.6.16.

I didn't even know there *was* a bugzilla.novell.com - and I've been
digging around Novell's site (and Googling around it from outside) for
what seems to me like quite a while. From the looks of things, however,
they don't have a category for ZENworks or for imaging, and the Linux
I'm using is not one of the SUSE-based distros they do list. (The
environment on the boot disc itself doesn't really qualify as any kind
of distro at all.)

Unfortunately, from what I've seen elsewhere it looks as if they are A:
not interested in supporting use any Linux except for their own SUSE for
this purpose and B: not likely to be open to supporting or even helping
with a customized environment; all of their technical documentation on
the subject is geared towards adding files and drivers to their existing
environment, not to replacing the entire kernel of that environment or
working with the results. Given that I'm building complete replacement
kernels and customizing rather a number of other things in the end
product, I'm rather inclined to suspect that even if I got into contact
with them about this they would say something to the effect of "since
you're not using our official environment, we won't/can't spend time and
effort trying to help you".

-- 
    Andrew Buehler
