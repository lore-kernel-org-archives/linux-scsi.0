From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC PATCH 0/2] block,scsi: support host-wide tagset
Date: Tue, 4 Apr 2017 16:25:29 +0000
Message-ID: <BY1PR0401MB153254F95E5227D93D197BDD810B0@BY1PR0401MB1532.namprd04.prod.outlook.com>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
 <CACVXFVPyWL8XyFKC9uT7r4q+QT1+_RvnvJnOskCO3aSnUEVY1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/04/2017 09:00 AM, Ming Lei wrote:=0A=
> Just be curious, why is multi hard queue used for this case? Are there=0A=
> some real cases in SCSI?=0A=
=0A=
Hello Ming,=0A=
=0A=
Yes, there is a real need for this. Background information is available=0A=
in the following e-mail thread: Arun Easi, "scsi-mq - tag# and=0A=
can_queue, performance", April 2, 2017, linux-scsi=0A=
(http://www.spinics.net/lists/linux-scsi/msg106853.html).=0A=
=0A=
Bart.=0A=
