From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 24 Apr 2017 23:46:36 +0000
Message-ID: <1493077595.3394.32.camel@sandisk.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
         <20170421234026.18970-11-bart.vanassche@sandisk.com>
         <yq1k269ij5f.fsf@oracle.com> <1493070575.3394.19.camel@sandisk.com>
         <yq1zif5fl61.fsf@oracle.com>
         <20170424232359.GA21578@vader.DHCP.thefacebook.com>
         <yq1r30hfkiv.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1r30hfkiv.fsf@oracle.com>
Content-Language: en-US
Content-ID: <DAC5E76F7AC445448754231BA51C9C91@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-04-24 at 19:33 -0400, Martin K. Petersen wrote:
> > The debugfs infrastructure is already there, and it already supports
> > showing requests. Bart is just exposing the SCSI information.
>=20
> That's fine.
>=20
> I was merely objecting to the fact that we already have umpteen existing
> interfaces for displaying SCSI command information.

Hello Martin,

Do you perhaps want me to change the for-loop into a call to
__scsi_format_command()?

Thanks,

Bart.=
