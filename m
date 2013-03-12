From: Mark Lord <kernel@start.ca>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system
 suspend
Date: Tue, 12 Mar 2013 12:34:08 -0400
Message-ID: <513F5900.9030503@start.ca>
References: <513D52BE.7040307@intel.com> <1362991742.2395.9.camel@dabdike.int.hansenpartnership.com> <CADLC3L1+z=Nx_MFBz60z3Ow_98hetLYDjK5On-zxwdpUf+quzA@mail.gmail.com> <1363013464.2395.63.camel@dabdike.int.hansenpartnership.com> <CADLC3L0nM+3ttR8V8cCOZWGY+eJqGZdmKiTRieYr_d+Xqh36UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mouse.start.ca ([64.140.120.56]:58221 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab3CLQzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Mar 2013 12:55:46 -0400
In-Reply-To: <CADLC3L0nM+3ttR8V8cCOZWGY+eJqGZdmKiTRieYr_d+Xqh36UA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Aaron Lu <aaron.lu@intel.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 13-03-11 03:30 PM, Robert Hancock wrote:
..
> I'm sure there are some SSDs that do violate their data integrity
> commitments - a while ago some tests were done (don't have a link
> handy and I don't think they identified the actual vendor/model of the
> drives in any case) but there were definitely some SSDs that did do
> nasty things like trash unrelated data if power was lost while
> writing, etc. So we definitely don't want to risk this sort of thing
> occurring on a normal power-off or suspend.


Just about all current SATA SSDs advertise having some form(s)
of "background garbage collection".  That "feature" has always concerned me,
because of the real possibility of power being removed (system shutdown)
while the drive firmware is in the midst of re-shuffling my data around.

One would hope that "STANDBY IMMEDIATE" is taken by the drive
as a signal to stop that fussing about and prepare for full/sudden power-off.

