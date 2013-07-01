From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v12 3/6] Restrict device state changes allowed via sysfs
Date: Mon, 1 Jul 2013 14:51:03 +0000
Message-ID: <1372690263.2385.21.camel@dabdike>
References: <51CC5176.90609@acm.org> <51CC522A.4010805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:45079 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3GAOvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 10:51:11 -0400
In-Reply-To: <51CC522A.4010805@acm.org>
Content-Language: en-US
Content-ID: <1F3F8BBEA0CD9D4E979B15C3BF53109A@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On Thu, 2013-06-27 at 16:54 +0200, Bart Van Assche wrote:
> Restrict the SCSI device state changes allowd via sysfs to the
> OFFLINE<>RUNNING transitions. Other transitions may confuse
> the SCSI mid-layer. As an example, changing the state of a SCSI
> device via sysfs into "cancel" or "deleted" prevents removal of
> a SCSI device by scsi_remove_host().

This one's not ready for application.  I would like a debate on what we
should be doing.  Currently we don't apply any sanity checking at all.
Should we?  And should we police user state changes.  If so, What
changes should we allow?  I opine that really only OFFLINE <-> RUNNING
make sense, but I've no idea what people actually use this field for (if
they use it at all).

James


