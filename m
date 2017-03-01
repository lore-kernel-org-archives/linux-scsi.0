From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] mpt3sas: Avoid sleeping in interrupt context
Date: Wed, 1 Mar 2017 17:32:09 +0000
Message-ID: <1488389500.2699.9.camel@sandisk.com>
References: <20170301170036.11540-1-bart.vanassche@sandisk.com>
         <20170301170458.GA3486@vader.DHCP.thefacebook.com>
         <1488388175.2699.7.camel@sandisk.com>
         <20170301172840.GB3486@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170301172840.GB3486@vader.DHCP.thefacebook.com>
Content-Language: en-US
Content-ID: <BEC61EEE370E1645951C71F457A02B2E@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>
Cc: "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-03-01 at 09:28 -0800, Omar Sandoval wrote:
> Just tried on blk-mq and I didn't get the splat, seems to be fine.

Thanks for the testing!

Bart.
