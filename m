From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH 9/9] osd_protocol.h: Add missing #include
Date: Mon, 16 Nov 2009 18:57:41 +0000
Message-ID: <20091116185741.GH8113@deprecation.cyrius.com>
References: <4B019BEC.3080909@panasas.com>
 <1258397365-356-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:36032 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZKPS5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 13:57:45 -0500
Content-Disposition: inline
In-Reply-To: <1258397365-356-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

* Boaz Harrosh <bharrosh@panasas.com> [2009-11-16 20:49]:
> From: Martin Michlmayr <tbm@cyrius.com>
> 
> include/scsi/osd_protocol.h uses ALIGN() without an #include
> <linux/kernel.h>, leading to:
> | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'

Note that this patch also has to go into 2.6.32, where OSD currently
builds to build (at least on ARM).
-- 
Martin Michlmayr
http://www.cyrius.com/
