From: Ewan Milne <emilne@redhat.com>
Subject: Re: [dm-devel] ALUA - rescan device capacity on zero sized block
 devices
Date: Fri, 12 Jun 2015 12:59:57 -0400
Message-ID: <1434128397.22842.102.camel@localhost.localdomain>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	 <552C008A.9070201@sandisk.com>
	 <987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
	 <552CCC77.9040703@suse.de>	<552CE2C2.8000809@sandisk.com>
	 <CABr-GnefEhc_dOKs360Hox7asbvO5qN8BqPczqC+V8CQ6Myh8w@mail.gmail.com>
	 <55349580.1040205@suse.de>
	 <1433948530.27387.92.camel@localhost.localdomain>
	 <55792206.3090505@suse.de>
	 <1434122272.22842.80.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbbFLQ76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 12:59:58 -0400
In-Reply-To: <1434122272.22842.80.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Christophe Varoqui <christophe.varoqui@opensvc.com>

On Fri, 2015-06-12 at 11:17 -0400, Ewan Milne wrote:
> There's an interesting, somewhat-related issue I've come across with
> iSCSI storage, when an event happens while the connection is not
> established (i.e. link down, or logged out for some reason).  The T10
> spec says that UAs are supposed to be reported on the I-T nexuses,

... but if the I-T nexus doesn't exist when the event occurs, it
doesn't get reported when the nexus is re-established, and it does
not seem like there is any requirement to do so.

