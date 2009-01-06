From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 07/18] osd_ktests: Add basic OSD tests
Date: Tue, 06 Jan 2009 18:49:53 +0200
Message-ID: <49638BB1.1060707@panasas.com>
References: <49636507.8060808@panasas.com> <1231251436-9777-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:40200 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZAFQt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 11:49:59 -0500
Received: by ewy10 with SMTP id 10so8529736ewy.13
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2009 08:49:57 -0800 (PST)
In-Reply-To: <1231251436-9777-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Boaz Harrosh wrote:
> Currently testing what is implemented in the osd_initiator library.
> That is - format, create/remove partition, create/remove object,
> read and write to objects.
> 
> This test passes against the IBM-OSD-SIM OSDv1 target.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Reviewed-by: Benny Halevy <bhalevy@panasas.com>

James hi if it is decided to drop the in kernel test
then Just drop this patch. After using:
  [PATCH ver2 05/16] osd_uld: OSD scsi ULD

I sent as reply to the patch it replaces

Thanks
Boaz
