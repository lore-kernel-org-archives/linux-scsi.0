From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: Add "missing" sysfs attribute to scsi_device
 structure
Date: Mon, 18 Nov 2013 09:45:56 -0800
Message-ID: <1384796756.5985.3.camel@dabdike.int.hansenpartnership.com>
References: <1384794656-9449-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57419 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab3KRRp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Nov 2013 12:45:59 -0500
In-Reply-To: <1384794656-9449-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-11-18 at 12:10 -0500, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> This change adds a "missing" sysfs attribute to scsi_device
> which is set when a previously scanned device no longer appears
> in the REPORT LUNS inventory.

A sysfs parameter with time and external input dependent semantics
really doesn't look like a good idea.  What is it you're trying to
achieve that you can't achieve from userspace by watching for the
events?

James


