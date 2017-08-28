From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 2/4] hpsa: remove the smp_handler stub
Date: Mon, 28 Aug 2017 18:41:59 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8E84F5@avsrvexchmbx1.microsemi.net>
References: <20170825153741.5091-1-hch@lst.de>,<20170825153741.5091-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0086.outbound.protection.outlook.com ([104.47.37.86]:30752
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751275AbdH1SmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 14:42:05 -0400
In-Reply-To: <20170825153741.5091-3-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Bart Van Assche <bart.vanassche@wdc.com>

________________________________________=0A=
From: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org] o=
n behalf of Christoph Hellwig [hch@lst.de]=0A=
Sent: Friday, August 25, 2017 8:37 AM=0A=
To: Chaitra Basappa; linux-scsi@vger.kernel.org=0A=
Cc: Bart Van Assche=0A=
Subject: [PATCH 2/4] hpsa: remove the smp_handler stub=0A=
=0A=
EXTERNAL EMAIL=0A=
=0A=
=0A=
The SAS transport class will do the right thing and not register the BSG=0A=
node if now smp_handler method is present.=0A=
=0A=
Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
=0A=
Acked-by: Don Brace <don.brace@microsemi.com>=0A=
