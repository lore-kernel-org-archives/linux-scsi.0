From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Thu, 4 May 2017 15:32:44 +0000
Message-ID: <1493911964.2692.4.camel@sandisk.com>
References: <20170503180911.24326-1-bart.vanassche@sandisk.com>
         <20170504073013.GA3684@lst.de> <1493911596.2692.2.camel@sandisk.com>
         <20170504151525.GA16489@sbauer-Z170X-UD5>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170504151525.GA16489@sbauer-Z170X-UD5>
Content-Language: en-US
Content-ID: <03A281746741B0458CEFDD509EDDACDF@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "scott.bauer@intel.com" <scott.bauer@intel.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "jack@suse.cz" <jack@suse.cz>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-04 at 09:15 -0600, Scott Bauer wrote:
> On Thu, May 04, 2017 at 03:26:37PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-05-04 at 09:30 +0200, Christoph Hellwig wrote:
> > > Please just add a flag to ->flags instead of adding a whole new field=
.
> > >=20
> > > Otherwise this looks good to me.
> >=20
> > Hello Christoph,
> >=20
> > Thanks for the feedback. I will make the proposed change and post a sec=
ond
> > version.
>=20
> BTW, what branch was your last patch based off? I had some hunk errors wh=
ile
> applying it.

Hello Scott,

That patch was based off kernel v4.11. Did you perhaps use a different kern=
el
version for your tests?

Bart.=
