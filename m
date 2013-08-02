From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 00/10] Enhanced Unit Attention handling
Date: Fri, 02 Aug 2013 10:05:48 -0700
Message-ID: <1375463148.2062.27.camel@dabdike.int.hansenpartnership.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43486 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab3HBRFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Aug 2013 13:05:50 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-08-01 at 16:57 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
> to provide enhanced support for Unit Attention conditions.

Well it doesn't really does it?  As I see it, patches 1-6 are trivial
changes unrelated to this so just roll them up and resend as a single
patch later when we've got the actual real stuff sorted out (except
patch 6 which looks bogus), patch 7 should be part of patch 8 which is
the actual unit attention events, patch 9 is an extension of scsi_debug
to generate UAs which needs to go separately via Doug and patch 10 is an
unrelated addition of a scan target parameter.

James


