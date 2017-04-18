From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Tue, 18 Apr 2017 15:34:38 +0000
Message-ID: <1492529676.2689.2.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24383 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdDRPer (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:34:47 -0400
In-Reply-To: <20170418144429.GA28949@bblock-ThinkPad-W530>
Content-Language: en-US
Content-ID: <3AD9751307EEE94CA2C84EFCFBEB82B4@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "maxg@mellanox.com" <maxg@mellanox.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-04-18 at 16:44 +0200, Benjamin Block wrote:
> I still wonder why we try 'so hard' scheduling a command for a dead
> device, but as that seems to be the status quo, and only lacks in the
> case where the LLD is already half-way gone, its ok for me too. I mean,
> the order is a bit screwed.. we apparently first remove the driver and
> post-factum try to drain the queue.. that is strange.

Hello Benjamin,

That's indeed strange. But I'm not sure whether it is possible to address
this without changing all SCSI LLDs.

Bart.=
