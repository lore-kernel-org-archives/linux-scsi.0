From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: remove final hosts.h usage removal
Date: 19 Jun 2004 10:41:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087659680.1747.77.camel@mulgrave>
References: <20040619153341.GA28055@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:15498 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264044AbUFSPl2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 11:41:28 -0400
In-Reply-To: <20040619153341.GA28055@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, gregkh@kroah.com

On Sat, 2004-06-19 at 10:33, Arjan van de Ven wrote:
> the patch eblow finishes off the removal of the obsolete hosts.h usage, and
> now that the users are gone, it's safe to turn on the warning to
> prevent accidental future use... Please apply

Er, a quick look in drivers/scsi/arm shows it still to be in use...

jejb@mulgrave> grep hosts\\.h drivers/scsi/arm/*.c
drivers/scsi/arm/acornscsi.c:#include "../hosts.h"
drivers/scsi/arm/arxescsi.c:#include "../hosts.h"
drivers/scsi/arm/cumana_1.c:#include "../hosts.h"
drivers/scsi/arm/cumana_2.c:#include "../hosts.h"
drivers/scsi/arm/ecoscsi.c:#include "../hosts.h"
drivers/scsi/arm/eesox.c:#include "../hosts.h"
drivers/scsi/arm/fas216.c:#include "../hosts.h"
drivers/scsi/arm/oak.c:#include "../hosts.h"
drivers/scsi/arm/powertec.c:#include "../hosts.h"

James


