From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Un-remove aacraid devices
Date: Wed, 23 May 2007 12:35:08 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B5C@otce2k301.adaptec.com>
References: <465438AD.8000406@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51043 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935424AbXEWQfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 12:35:16 -0400
Content-class: urn:content-classes:message
In-reply-to: <465438AD.8000406@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

NAK

This will break all our management applications, and will not allow us =
to manipulate the array configurations from within Linux. This will als=
o break online expansion of capacity.

This flag has been set from the beginning to allow partition tables, ca=
pacity and device locking to be changed without requiring an intervenin=
g reboot or needing the device to be taken offline. Fixed disk result i=
n these pieces of information being cached.

Sincerely -- Mark Salyzyn

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Hannes Reinecke
Sent: Wednesday, May 23, 2007 8:51 AM
To: Salyzyn, Mark
Cc: SCSI Mailing List
Subject: [PATCH] Un-remove aacraid devices

Hi Mark,

for some weird reason the aacraid driver insists on presenting all disk=
s
as 'removable' devices. This is gross hackery and causes userspace tool=
s
to not identify these devices as fixed disks, which most evidently they=
 are.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
