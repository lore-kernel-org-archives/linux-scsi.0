From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Wed, 29 Jul 2009 08:56:03 -0500
Message-ID: <1248875763.3900.1.camel@mulgrave.site>
References: <20090729111114.GA15239@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39730 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbZG2N4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 09:56:09 -0400
In-Reply-To: <20090729111114.GA15239@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
> scsi/scsi.h is exported to userspace, so it should
> use __u8 instead of u8 as other userspace-visible headers do.

Actually, can we just put a hold on this until we decide what we're
doing with exporting include/scsi.

Arguments so far are

     1. Don't export and let glibc supply the headers (as it does now)
     2. Move headers to be exported to include/linux
     3. Take over include/scsi export from glibc: this will necessitate
        comparing our current headers and those of glibc and moving
        stuff around.

James


