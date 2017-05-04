From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Thu, 4 May 2017 15:26:37 +0000
Message-ID: <1493911596.2692.2.camel@sandisk.com>
References: <20170503180911.24326-1-bart.vanassche@sandisk.com>
         <20170504073013.GA3684@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170504073013.GA3684@lst.de>
Content-Language: en-US
Content-ID: <DB1700420D26EE478E7DC0884325BB68@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "scott.bauer@intel.com" <scott.bauer@intel.com>, "jack@suse.cz" <jack@suse.cz>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-04 at 09:30 +0200, Christoph Hellwig wrote:
> Please just add a flag to ->flags instead of adding a whole new field.
>=20
> Otherwise this looks good to me.

Hello Christoph,

Thanks for the feedback. I will make the proposed change and post a second
version.

Bart.=
