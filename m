From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] first cut at infrastructure for handling different device types in the sas class
Date: Sat, 4 Mar 2006 00:28:42 -0800 (PST)
Message-ID: <20060304082842.74493.qmail@web31813.mail.mud.yahoo.com>
References: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:50098 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751576AbWCDI2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 03:28:43 -0500
In-Reply-To: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> This one actually does the end devices, since that's all I really have
> to work with in my setup.  However, I can do the expanders in the same
> way.
***************************************************************************
> The idea is to make the rphy embedded in the enveloping device
> structure, so the code which doesn't care about type can still treat the
> code as a simple rphy, and the code that does care can cast out to the
> device type.
***************************************************************************

James, this doesn't make sense in SAS.  Maybe you're implementing some other
protocol, but what you have here isn't SAS.  You need to understand
what a port is and what a phy is.  Then you need to understand
their (mutual) interactions.  What each one represents (or doesn't) and
their dependencies.

Then you need to understand why you don't want to represent any of those
two concepts for anything past your own ports.

True, it's all open sourced in the complete SAS Stack, but reverse-engineering
the logic isn't easy without studying the SAS spec.

> If everyone's OK with this, I'll do expanders next.

Please don't.

They are done already, sas_expander.c is the file.

