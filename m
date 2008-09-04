From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/15] lpfc 8.2.8 : Add sysfs control of target queue
	depth handling
Date: Thu, 04 Sep 2008 16:20:08 -0500
Message-ID: <1220563208.3276.62.camel@localhost.localdomain>
References: <1219629024.7890.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53179 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbYIDVUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 17:20:10 -0400
In-Reply-To: <1219629024.7890.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Sun, 2008-08-24 at 21:50 -0400, James Smart wrote:
> Added new sysfs attribute lpfc_max_scsicmpl_time. Attribute, when enabled,
> will control target queue depth based on I/O completion time.

This one's throwing rejections all over too, but the rest of the patch
series seems to survive without it, so I just dropped it.

James


