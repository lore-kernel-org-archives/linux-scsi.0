From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 10:24:58 -0800 (PST)
Message-ID: <20060303182458.25295.qmail@web31813.mail.mud.yahoo.com>
References: <440865F0.1000500@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:25192 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1161016AbWCCSY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 13:24:59 -0500
In-Reply-To: <440865F0.1000500@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Mark Rustad <mrustad@mac.com>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Same for SBP-2. This is old and has been solved before.
> 
> Neither attempts to enforce a specific order of device registering, nor
> a delay of an module init routine in order to wait for completion of
> device discovery is a proper solution. Let alone an empirically chosen
> delay.

BIOSes accomplish this task.

> Create an initrd. Put the necessary hotplug infrastructure into the
> initrd. This includes
>  - reacting on device hotplugs,
>  - mapping persistent unique device identifiers or unique partition
>    identifiers to mount points,
> i.e. basically everything which has to be done for hotpluggable devices.
> 
> (Put policy into userspace. Let the kernel provide mechanism only.)

Yes, this is a very good idea.

      Luben

