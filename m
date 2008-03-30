From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 02/17] Dell CERC support for megaraid_mbox
Date: Sun, 30 Mar 2008 12:13:40 -0500
Message-ID: <1206897220.4224.50.camel@localhost.localdomain>
References: <200803282148.m2SLmXhQ012219@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42314 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbYC3RNo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 13:13:44 -0400
In-Reply-To: <200803282148.m2SLmXhQ012219@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, hare@suse.de, Bo.Yang@lsi.com, Sumant.Patro@lsi.com

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Newer Dell CERC firmware (>= 6.62) implement a random deletion handling
> compatible with the legacy megaraid driver.  The legacy handling shifted
> the target ID by 0x80 only for I/O commands (READ/WRITE/etc), whereas
> megaraid_mbox shifts the target ID always if random deletion is supported. 
> The resulted in megaraid_mbox sending an INQUIRY to the wrong channel, and
> not finding any devices, obviously.
> 
> So we disable the random deletion support if the offending firmware is
> found.
> 
> Addresses http://bugzilla.kernel.org/show_bug.cgi?id=6695

Bo,

You said you'd review this patch and give feedback "soon" twenty five
days ago (5 March).  My patience finally ran out on this one; you have
three days (that's until midnight CST on 2 April) to provide an ack or a
replacement patch for this otherwise I'll apply it anyway.

James


