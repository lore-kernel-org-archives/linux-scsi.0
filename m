From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 17:49:58 -0700 (PDT)
Message-ID: <748779.88428.qm@web31804.mail.mud.yahoo.com>
References: <1182808124.3461.17.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:23844 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035AbXFZAt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 20:49:59 -0400
In-Reply-To: <1182808124.3461.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> You're sort of confusing what we display as the LUN and what we
> represent it as internally (admittedly they're the same at the moment).
> The object would be to separate these and the debate is really about
> what to display.

Display this:
 "%016llx", ((unsigned long long) be64_to_cpu(*(__be64 *)(LUN))),
where LUN is u8[8].  Notice the ugly, C-centric "0x" prefix
is missing.  Not sure who would confuse this number for decimal
or octal base representation of a LUN...

This also makes it great to be a directory name, since it is the
same width and format, and it looks great in "tree" listing format,
as shown in here:
http://marc.info/?l=linux-scsi&m=112629509826900&w=2

    Luben

