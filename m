From: Dave Jones <davej@redhat.com>
Subject: Re: strange comparison in be2iscsi
Date: Thu, 24 Oct 2013 05:42:44 -0400
Message-ID: <20131024094244.GB19018@redhat.com>
References: <20131024084721.GA15720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3JXJmw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Oct 2013 05:42:52 -0400
Content-Disposition: inline
In-Reply-To: <20131024084721.GA15720@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohank@serverengines.com
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 24, 2013 at 04:47:21AM -0400, Dave Jones wrote:
 > A few years ago, in 4183122dbc7c489f11971c5afa8e42011bca7fa2
 > this code was added to drivers/scsi/be2iscsi/be_main.c
 > 
 > +               if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
 > +                       continue;
 > 
 > Which doesn't make a lot of sense.
 > What was the intent here ?

Also elsewhere we have this..

6733b39a        (Jayamohan Kallickal    2009-09-05 07:36:35 +0530       1583)   phys_addr.u.a64.address =
6733b39a        (Jayamohan Kallickal    2009-09-05 07:36:35 +0530       1584)                   *((unsigned long long *)(&phys_addr.u.a64.address));


which looks like a pretty convoluted way to assign a var to itself.

	Dave 
