From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 10/35] hpsa: add hp_ssd_smart_path_enabled sysfs
 attribute
Date: Thu, 13 Mar 2014 15:28:14 +0400
Message-ID: <1394710094.2192.20.camel@dabdike>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
	 <20140218195554.15787.37119.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43099 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261AbaCMOSC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2014 10:18:02 -0400
In-Reply-To: <20140218195554.15787.37119.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

On Tue, 2014-02-18 at 13:55 -0600, Stephen M. Cameron wrote:
> From: Scott Teel <scott.teel@hp.com>
> 
> Signed-off-by: Scott Teel <scott.teel@hp.com>
> Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Just a note: when you send a patch to me, that should be signed-off-by.
It's because you're part of the transmission path under the DCO (which
the signoffs track).  When you want me to apply a patch someone else
sends in, you either resend it to me with your signoff or just ack it
(acked by means you approve it but didn't resend it to me).

I've altered all the acks from you in this series to signoffs.

James


