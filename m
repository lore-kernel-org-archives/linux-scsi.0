From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Date: Wed, 16 Jul 2014 17:26:48 +0000
Message-ID: <e6f205c16ba2414ab5645977ac038e6c@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <53C37575.5030808@suse.de> <20140714083047.GB22715@infradead.org>
 <53C39B91.4010000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <53C39B91.4010000@suse.de>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, July 14, 2014 1:58 AM
> To: Christoph Hellwig
> Cc: KY Srinivasan; jasowang@redhat.com; apw@canonical.com; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to =
reflect
> the values on the host
> =

> On 07/14/2014 10:30 AM, Christoph Hellwig wrote:
> > On Mon, Jul 14, 2014 at 08:15:17AM +0200, Hannes Reinecke wrote:
> >> Limiting max_lun to 255 will make the driver to _not_ respond to LUNs
> >> higher than that; ie Well-known LUN won't work here.
> >> Also the SCSI stack will be using REPORT LUNS anyway since you're
> >> advertising SPC-2 compliance. So your driver runs into issues if
> >> Hyper-V would ever return more than 256 LUNs with the REPORT LUN
> >> command or if any of the LUNs has an addressing scheme other than
> >> '0x00'.
> >> I would suggest to raise this to the technical limit (ie the largest
> >> LUN which the _protocol_ supports) and let REPORT LUNS deal with the
> >> actual LUNs.
> >
> > I suspect hypverv doesn't support anything more.  For now I'd be
> > inclined to just put it in ASAP and if your suggestion works out fix
> > it up later, although I'll wait a bit for more review feedback.
> >
> Okay, that's fine by me.

Christoph,

Is this patch-set ready to be checked in. Let me know if you want me to mak=
e any
further corrections.

Regards,

K. Y
> =

> Cheers,
> =

> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
