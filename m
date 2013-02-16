From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG_SCSI_RESET ioctl: add no_escalate values
Date: Sat, 16 Feb 2013 00:44:54 -0600
Message-ID: <A979542D-930F-4D70-844C-5F25BF9C19DF@cs.wisc.edu>
References: <511E8EF7.3010004@interlog.com> <511EAD33.7000901@cs.wisc.edu> <511EC5A2.9080107@interlog.com> <6C2A267D-259E-43B4-A06F-AF09B537F9E6@cs.wisc.edu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32839 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3BPGpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 01:45:03 -0500
In-Reply-To: <6C2A267D-259E-43B4-A06F-AF09B537F9E6@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>


On Feb 15, 2013, at 11:45 PM, Michael Christie <michaelc@cs.wisc.edu> wrote:
>>> Some drivers rely on more invasive eh callbacks to be called if they
>>> return FAILED in a eh callbacks.


> If userspace sends a command that performs the non-escalting *reset to some drivers, it is going to leave them in a state where they may not process IO or will crash.

Actually, I take those 2 comments back. I think it is just some drivers abort callbacks that might be issues, so we should be safe. I did not look at all drivers though.