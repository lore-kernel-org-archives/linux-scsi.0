From: Mark Lord <mlord@pobox.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 08:32:02 -0400
Message-ID: <4E451D42.5050809@pobox.com>
References: <4E43F2C3.9000808@computerix.info>
 <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com>
 <4E44DE8E.3070809@computerix.info> <4E44E13B.2050503@gmail.com>
 <4E44E8E5.4040707@computerix.info> <4E44EBF4.8050801@gmail.com>
 <4E44F14F.1020206@computerix.info>
 <alpine.LFD.2.00.1108121143430.4535@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:48836 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1HLMcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 08:32:04 -0400
In-Reply-To: <alpine.LFD.2.00.1108121143430.4535@dhcp-27-109.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>, Ric Wheeler <ricwheeler@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On 11-08-12 05:52 AM, Lukas Czerner wrote:
..
> wiper.sh is just a hack to do rally nasty thing to the filesystam
> (allocating all free space)

It actually does NOT allocate all of the free space,
but yes it does reserve *most* of it, leaving a few percent
or a few hundred MB free while it issues the DSM/TRIM commands.

And it uses the fallocate system call, so the reserved space
is not actually written to when reserved, nor when later freed.

I expect the next version of it to include support for FSTRIM,
but that is a much slower method, especially for offline TRIM.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
