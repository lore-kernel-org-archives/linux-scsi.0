From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Sat, 25 May 2013 14:56:07 +0200
Message-ID: <51A0B4E7.4030307@redhat.com>
References: <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org> <519F12FF.6090809@redhat.com> <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com> <1369456502.5008.5.camel@dabdike> <20130525083713.GA6179@mtj.dyndns.org> <51A09D1D.3040706@redhat.com> <20130525124814.GA8489@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33356 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3EYM4T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 May 2013 08:56:19 -0400
In-Reply-To: <20130525124814.GA8489@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Il 25/05/2013 14:48, Tejun Heo ha scritto:
>>> * Merge the patch to give out SG_IO access along with write access, so
>>> > >   the use cases which want to give out SG_IO access can do so
>>> > >   explicitly and be fully responsible for the device.  This makes
>>> > >   sense to me.  If one wants to be allowed to issue raw commands to
>>> > >   the hardware, one takes the full responsibility.
>> > 
>> > That's not possible; it would make it impossible to do things like using
>> > a privileged helper to open the file and passing it back via SCM_RIGHTS
>> > to an unprivileged program (running as the user).  This is the ptrace
>> > attack that you mentioned.
> I have no idea what you're talking about.  I'm describing the same
> thing you implemented and posted.

Ok, I think we need a rewind.  I'll try to post what I mean next week.

Paolo
