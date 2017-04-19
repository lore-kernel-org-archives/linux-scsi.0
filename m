From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Wed, 19 Apr 2017 00:02:22 +0000
Message-ID: <1492560140.2689.30.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36485 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757514AbdDSACY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 20:02:24 -0400
In-Reply-To: <1492559772.3306.58.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <D0F33E0628DB87419E45280F33B38104@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-04-18 at 16:56 -0700, James Bottomley wrote:
> Actually, I think 3/3 is wrong.  You need to start the queue as soon as
> we see it's blocked and the device has gone into DEL.  This is safe
> because DEL ensures nothing ever gets from the generic request function
> to queuecommand, so the device driver never sees anything.

Hello James,

I agree that restarting the queue earlier is safe but I do not agree that
patch 3/3 is wrong. Can you explain why you think that patch 3/3 is wrong?

Thanks,

Bart.=
