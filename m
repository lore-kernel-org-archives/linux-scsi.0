From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 8/18] megaraid_sas : Add release date and update
 driver version
Date: Tue, 21 Apr 2015 12:27:37 +0200
Message-ID: <55362619.1040506@suse.de>
References: <201504201235.t3KCZqwd016586@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbbDUK1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:27:39 -0400
In-Reply-To: <201504201235.t3KCZqwd016586@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
> This patch will upgrade the driver version and add back the release d=
ate and sysfs hook for the same.
> Some internal applications uses sysfs parameter for release date, so =
they were broken because of removal
> of release date from sysfs.
> =20
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
