From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use proper seq_file api for /proc/scsi/scsi
Date: Thu, 07 Apr 2005 13:21:23 +0200
Message-ID: <425517B3.2010702@suse.de>
References: <42550173.1040503@suse.de> <20050407103123.GB9586@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35756 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262429AbVDGLVa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2005 07:21:30 -0400
In-Reply-To: <20050407103123.GB9586@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Thu, Apr 07, 2005 at 11:46:27AM +0200, Hannes Reinecke wrote:
>>Hi all,
>>
>>/proc/scsi/scsi currently has a very dumb implementation of the seq_f=
ile
>>api which causes 'cat /proc/scsi/scsi' to return with -ENOMEM when a
>>large amount of devices are connected.
>=20
> /proc/scsi/scsi is deprecated and even only compiled in if
> "legacy /proc/scsi/ support" is enabled.  Please move over to lssci w=
hich
> is using sysfs ASAP.
>=20
Ah. And that's enough reason for it not to work properly?
Deprecated as it may be, but one could at least expect it to _work_.

Puzzled.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
