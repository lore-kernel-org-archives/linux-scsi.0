From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Proposed fix for scsi related boot crash
Date: Thu, 19 Jan 2012 16:10:15 -0500
Message-ID: <1327007415.3025.19.camel@dabdike>
References: <20120119114127.GC6514@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53385 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab2ASVKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:10:18 -0500
In-Reply-To: <20120119114127.GC6514@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2012-01-19 at 12:41 +0100, Stanislaw Gruszka wrote:
> Hi
> 
> We have fedora bug report where system crash at boot when SCSI card is
> plugged into the system:
> https://bugzilla.redhat.com/show_bug.cgi?id=781625

It will be fixed in stable by

commit cced5041ed5a2d1352186510944b0ddfbdbe4c0b
Author: Stratos Psomadakis <psomas@gentoo.org>
Date:   Sun Dec 4 02:23:54 2011 +0200

    [SCSI] sym53c8xx: Fix NULL pointer dereference in slave_destroy


James


