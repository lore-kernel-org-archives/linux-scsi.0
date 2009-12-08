From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] scsi_dh_rdac: Add two new IBM devices to
	rdac_dev_list
Date: Tue, 8 Dec 2009 08:55:58 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF487663E4C@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF48744CE36@cosmail01.lsi.com>
	<1257370545.21609.10.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257370545.21609.10.camel@chandra-ubuntu>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James,
  Can you please pick this up?
Thanks
Babu Moger=20

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Wednesday, November 04, 2009 3:36 PM
> To: Moger, Babu
> Cc: linux-scsi@vger.kernel.org; Chauhan, Vijay; dm-devel@redhat.com
> Subject: Re: [PATCH] scsi_dh_rdac: Add two new IBM devices to
> rdac_dev_list
>=20
> Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
>=20
> On Wed, 2009-11-04 at 12:36 -0700, Moger, Babu wrote:
> > This patch adds two new IBM storage devices which can use rdac device
> handlers.
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > ---
> > --- linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 	2009-11-03 16:06:58.677451876 -0600
> > +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-
> 11-03 16:08:29.725570987 -0600
> > @@ -666,6 +666,8 @@ static const struct scsi_dh_devlist rdac
> >  	{"IBM", "1724"},
> >  	{"IBM", "1726"},
> >  	{"IBM", "1742"},
> > +	{"IBM", "1745"},
> > +	{"IBM", "1746"},
> >  	{"IBM", "1814"},
> >  	{"IBM", "1815"},
> >  	{"IBM", "1818"},
> >
> >
