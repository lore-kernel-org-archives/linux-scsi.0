From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 0/3] Unblock SCSI devices even if the LLD is being
 unloaded
Date: Mon, 10 Apr 2017 17:46:10 +0000
Message-ID: <1491846369.4199.17.camel@sandisk.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
         <1489704797.4650.8.camel@HansenPartnership.com>
         <1489706379.2574.24.camel@sandisk.com>
         <1489755268.2373.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:7242 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753648AbdDJRq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 13:46:29 -0400
In-Reply-To: <1489755268.2373.11.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <18FC5EA8E1B9204F8CC5650598811302@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-03-17 at 05:54 -0700, James Bottomley wrote:
> but if you want to pursue your approach fixing the
> race with module exit is a requirement.

Hello James,

Sorry that it took so long but I finally found the time to implement and
test an alternative. I will post the patches that implement that new approa=
ch.

Bart.=
