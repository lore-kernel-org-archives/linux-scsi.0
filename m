From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bus:id:lun to device name
Date: Thu, 17 Jul 2003 11:29:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717112951.A18620@infradead.org>
References: <OF19C5DBC5.6CF569E6-ON87256D64.005C1908-88256D64.005DBB45@us.ibm.com> <1058344192.3983.98.camel@lt-sv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:526 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S271387AbTGQKPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 06:15:00 -0400
Content-Disposition: inline
In-Reply-To: <1058344192.3983.98.camel@lt-sv>; from Stefan.Voelkel@millenux.com on Wed, Jul 16, 2003 at 10:29:52AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org

On Wed, Jul 16, 2003 at 10:29:52AM +0200, Stefan Voelkel wrote:
> Yes, basically. I have this information: host_id:bus:target:lun, and now
> I'd like the "device file name with which one normally access' this
> specific lun".

This is not possible in Linux as it's a userspace policy decision.
E.g. scsi cdrom devices at least have three commonly used naming schemes.

> Let me give you some details (hope that will make it clearer). I am
> implementing FC-HBA (ftp://ftp.t11.org/t11/pub/fc/hba/03-108v2.pdf). The
> problem occures with HBA_GetFcpTargetMapping() on page 73 (7.4.4), the
> parameters are describerd on page 31 (6.6.1) and the specific struct is
> HBA_ScsiId (6.6.1.5), actually the member OSDeviceName (6.6.2.11).

This doesn't make any sense in a linux enviroment.  I'd rather try to
get that draft fixed before it's ratified instead of working around
it especially as they already mention Linux in some examples.

OTOH it's probably totally irrelevant for real life anyway.

