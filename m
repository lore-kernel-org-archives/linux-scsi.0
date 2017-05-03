From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Wed, 3 May 2017 16:12:07 +0000
Message-ID: <1493827927.3901.7.camel@sandisk.com>
References: <20170502174330.13146-1-bart.vanassche@sandisk.com>
         <20170502230034.GA29151@sbauer-Z170X-UD5>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32134 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdECQMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 12:12:10 -0400
In-Reply-To: <20170502230034.GA29151@sbauer-Z170X-UD5>
Content-Language: en-US
Content-ID: <9186D20FBAF8444AA6ADDE8AA57463E9@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "scott.bauer@intel.com" <scott.bauer@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "jack@suse.cz" <jack@suse.cz>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Tue, 2017-05-02 at 17:00 -0600, Scott Bauer wrote:
> I've applied this on-top of Jens' For-Linus and re-ran the test. I get th=
e following scheduling
> while atomic BUG() splat:
>=20
> [   35.753764] BUG: scheduling while atomic: swapper/0/0/0x00000100
> [   35.754333]  [ ... ]
> [   35.765844]  scsi_host_dev_release+0xe7/0x430
> [   35.766155]  [ ... ]
> [   35.769636]  rcu_process_callbacks+0x831/0xfb0

Hello Scott,

Thanks for testing. It's weird that I had not hit this with my own tests.
Anyway, I will post a v2.

Bart.=
