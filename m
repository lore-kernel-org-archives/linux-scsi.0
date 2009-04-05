From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RFC PATCH 14/19] Target_Core_Mod SCSI MIBs
Date: Sun, 5 Apr 2009 09:03:09 +0200
Message-ID: <e2e108260904050003r65a43c8cy84cf6f6e5a26bce7@mail.gmail.com>
References: <1238904131.4250.755.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46087 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZDEHDN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2009 03:03:13 -0400
In-Reply-To: <1238904131.4250.755.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>, Philipp Reisner <philipp.reisner@linbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>

On Sun, Apr 5, 2009 at 6:02 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> This patch adds support for SCSI MIBs through /proc/scsi_target/mib following RFC-4455.

According to the Net-SNMP documentation, an implementation of the
SCSI-MIB (RFC 4455) for Linux does not yet exist
(http://www.net-snmp.org/docs/mibs/). It would be great once
implementation of this MIB starts, the kernel would offer a
well-documented interface that allows to query the information this
MIB exports. This interface can then be implemented in any SCSI target
for which these statistics are available in the kernel (SCST, IET,
LIO). This will allow a single implementation of RFC 4455 in the
Net-SNMP project instead of multiple.

The patch you posted exports the statistics needed by RFC 4455 through
a procfs interface. Sorry, but IMHO this information should be
exported in other way than through procfs.

Bart.
