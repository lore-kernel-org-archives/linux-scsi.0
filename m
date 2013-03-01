From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
Date: Fri, 01 Mar 2013 14:51:58 +0100
Message-ID: <5130B27E.9040003@redhat.com>
References: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com> <5130ACBE.8080300@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:39197 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CANwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 08:52:04 -0500
Received: by mail-qa0-f51.google.com with SMTP id cr7so2167050qab.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2013 05:52:02 -0800 (PST)
In-Reply-To: <5130ACBE.8080300@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

Il 01/03/2013 14:27, Douglas Gilbert ha scritto:
> What is the status of the:
>   - scsi: 64-bit LUN support [v2]
>   - SG_SCSI_RESET ioctl: add no_escalate values [v2]
> 
> patches?

Also:

[PATCH v2 00/14] Corrections and customization of the SG_IO command
whitelist (CVE-2012-4542)

Paolo
