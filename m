From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH 0/22] lpfc 8.1.2 driver update, crash in lpfc_worker_0
Date: Sun, 12 Feb 2006 16:26:31 +0100
Message-ID: <20060212152631.GA24631@suse.de>
References: <43EA10FC.3030008@emulex.com> <20060212145736.GA23765@suse.de> <1139757616.3808.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:44436 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750794AbWBLP0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 10:26:47 -0500
Content-Disposition: inline
In-Reply-To: <1139757616.3808.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>

 On Sun, Feb 12, James Bottomley wrote:

> Could you try to produce this on a non-ppc machine?

Yes, its an older pSeries, pre-POWER4. So far it did not reproduce on
this system after 3 reboots.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
