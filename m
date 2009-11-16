From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH 9/9] osd_protocol.h: Add missing #include
Date: Mon, 16 Nov 2009 19:09:32 +0000
Message-ID: <20091116190932.GI8113@deprecation.cyrius.com>
References: <4B019BEC.3080909@panasas.com>
 <1258397365-356-1-git-send-email-bharrosh@panasas.com>
 <20091116185741.GH8113@deprecation.cyrius.com>
 <4B01A174.8000005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:50541 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZKPTJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 14:09:39 -0500
Content-Disposition: inline
In-Reply-To: <4B01A174.8000005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

> > Note that this patch also has to go into 2.6.32, where OSD currently
> > builds to build (at least on ARM).
> 
> OK in that case we need to CC: stable@kernel.org, inside the patch

Why?  2.6.32 is not out yet, so James can simply include this patch in
his tree for Linus and ask him to pull.
-- 
Martin Michlmayr
http://www.cyrius.com/
