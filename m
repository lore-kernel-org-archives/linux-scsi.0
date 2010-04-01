From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Thu, 01 Apr 2010 10:15:46 +0200
Message-ID: <4BB45632.5020700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0DAIPs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2010 04:15:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

[Topic]
Handling of invalid requests in virtual HBAs

[Abstract]
This discussion will focus on the problem of correct request handling w=
ith virtual HBAs.
=46or KVM I have implemented a 'megasas' HBA emulation which serves as =
a backend for the
megaraid_sas linux driver.
It is now possible to connect several disks from different (physical) H=
BAs to that
HBA emulation, each having different logical capabilities wrt transfers=
ize,
sgl size, sgl length etc.

The goal of this discussion is how to determine the 'best' capability s=
etting for the
virtual HBA and how to handle hotplug scenarios, where a disk might be =
plugged in
which has incompatible settings from the one the virtual HBA is using c=
urrently.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
