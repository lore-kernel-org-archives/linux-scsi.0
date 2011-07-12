From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] be2iscsi: Fixing the /proc/interrupts problem V3
Date: Tue, 12 Jul 2011 12:21:52 -0500
Message-ID: <1310491313.16900.12.camel@mulgrave>
References: <1310490756-2210-1-git-send-email-jayamohan.kallickal@emulex.com>
	 <894955a8-23e3-4553-bfb5-614b2bc8ed93@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42265 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab1GLRVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2011 13:21:55 -0400
In-Reply-To: <894955a8-23e3-4553-bfb5-614b2bc8ed93@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Prarit Bhargava <prarit@redhat.com>

On Tue, 2011-07-12 at 10:12 -0700, jayamohan.kallickal@emulex.com wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
> This patch is based on one by Prarit Bhargava. I have made minor
> changes. Also, removed the redundant check for i == 0 and adding changelog  as suggested
> by Rolf.

This changelog doesn't actually say what the patch does.  From the
description, it sounds like a stable candidate, but I can't really tell.

Please send an actual description including what the problem was and
what was done to fix it.  What's above can be the last paragraph
recording the patch history.

James


