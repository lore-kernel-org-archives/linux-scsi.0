From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target subsystem
Date: Sun, 04 May 2008 15:35:51 +0400
Message-ID: <481D9F97.5090505@vlnb.net>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <1209745084.3121.39.camel@localhost.localdomain> <481B5AB8.5030108@vlnb.net> <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com> <20080503095314.GX14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:50404 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbYEDLfa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 07:35:30 -0400
In-Reply-To: <20080503095314.GX14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, May 03, 2008 at 11:41:41AM +0200, Bart Van Assche wrote:
>> On Fri, May 2, 2008 at 8:17 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> I wrote all above to support my at first glance shocking conclusion that
>>> SCSI target subsystem is completely new subsystem of the kernel and it
>>> should live on its own with its own maintainer! This is the same as with the
>>> current interaction between SCSI and block subsystems in the kernel: SCSI
>>> uses block's functionality, but that doesn't mean that block and SCSI are
>>> the same subsystem.
>> Hello Tomo,
>>
>> Due to the IET and STGT projects you have a lot of experience with
>> implementing SCSI target frameworks. What is your opinion about how a
>> kernel space SCSI target framework should fit in the Linux kernel ?
> 
> Bart, what is your role in the SCST project?  You don't seem to have
> contributed any code to it (going by the SVN logs on sourceforge), and
> your questions and suggestions seem to be those of someone not familiar
> with the code.  If you're not a developer, it might be more helpful for
> you to step back and let Vladislav handle this.

Consider Bart as a member of SCST team at the moment responsible for 
Linux kernel inclusion.

Vlad

