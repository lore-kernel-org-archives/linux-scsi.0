From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Mon, 14 Oct 2013 19:30:49 +0100
Message-ID: <1381775449.3752.9.camel@dabdike.lan>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>
	 <525BC836.2030306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56694 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab3JNSax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Oct 2013 14:30:53 -0400
In-Reply-To: <525BC836.2030306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Wangshen (C)" <peter.w@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Jinbo (Justin)" <jinbo@huawei.com>

On Mon, 2013-10-14 at 12:32 +0200, Hannes Reinecke wrote:
> On 10/12/2013 08:35 AM, Wangshen (C) wrote:
> > Hello everyone,
> > 
> > My name is Wang Shen.
> > I am developing some scsi devices in Linux needs 64bit lun.
> > Now I am in trouble in scsi driver programming.
> > 
> > According to SAM-5, a LUN structure is 8 bytes long, but it is only 4 bytes long in kernel.
> > In another word Linux kernel only supports single level LUN, except conglomerate LUN and Hierarchical LUN.
> > In my project, we need support all of the LUN structures.
> > 
> > I find an archive mail on Tue, 19 Feb 2013 which discussed "scsi: 64-bit LUN support", but it just a patchset.
> > 
> > Is there any plan to merge this patchset to mainline?
> > If there is a plan, Which version will support 64bit lun?
> 
> Yes, there is a plan. Sort of.
> 
> I have a patchset (basically an update from the original patches)
> sitting here in my private repository.
> 
> However, there are two other patchsets pending (EH Deadline and
> asynchronous command aborts), both of which have been tested
> thoroughly _and_ have acked-by from various other parties.
> None of these patchset had received any feedback from James
> Bottomley, let alone any indication if or when they'll be merged.
> 
> So I stopped sending further patchsets, sensing some communication
> breakdown on the line.

There's no communications breakdown, I've just been very busy.  EH
deadline looks OK, but let me look again to make sure.  Async aborts I'm
not necessarily keen on because I know a lot of devices where aborting
just confuses the firmware more, so I think skipping aborts and moving
to LUN reset might be a better form of acceleration.

James 

> I try to excite some response from James B. next week in Edinburgh.
> At the very least there'll be other persons with whom I'll be able
> to discuss further steps.
> 
> And yes, this is slightly irritating.
> 
> Cheers,
> 
> Hannes



