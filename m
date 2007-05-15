From: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Tue, 15 May 2007 12:26:29 +0100
Message-ID: <17841.simon.1179228389@5ec7c279.invalid>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
    <20070513160608.GA29024@redhat.com>
    <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
    <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
    <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
    <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
    <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
    <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
    <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
    <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:44257 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbXEOL0g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2007 07:26:36 -0400
In-Reply-To: <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, May 15, 2007 01:41, Satyam Sharma wrote:
> On 5/14/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
>> On Mon, 2007-05-14 at 17:53 +0530, Satyam Sharma wrote:
>> > > I guess this is probably the behaviour that James wanted originally?
>>
>> No ... you're still not reading the explanation in the thread:
>>
>> The wait scan module is designed to wait for scans of driver modules.
>> Whether SCSI=y or m has no effect on this ... you can still have modular
>> drivers with built in SCSI.
>
> Ah, I see why we _want_ this built as a _module_ only, and don't even
> want to expose the Kconfig option to the user, lest he screw himself later.
> But dangling "default m"'s or "default y"'s not exposed to the user do
> stand out discomfortingly in Kconfigs, wish there was a better way to
> handle this.

I've already suggested a sysfs attribute - or something equivalent - would
be much better. It's just one function that a user might want to run multiple
times (e.g. after adding scsi devices?) - why should loading a module be used
for this?

-- 
Simon Arlott
