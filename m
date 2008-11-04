From: "Nikanth Karthikesan" <KNikanth@novell.com>
Subject: Re: [PATCH 10/13] dm: add core functions
	forrequest-based dm
Date: Mon, 03 Nov 2008 22:33:31 -0700
Message-ID: <49102C03020000C50002E257@victor.provo.novell.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104612.115643090.k-ueda@ct.jp.nec.com>
	<807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
	<490FB852.3FEE.00C5.1@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <490FB852.3FEE.00C5.1@novell.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>"<Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>, nikanth@gmail.com, agk@redhat.com
Cc: linux-scsi@vger.kernel.org, knikanth@suse.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "<Andi Kleen" <andi@firstfloor.org>, jens.axboe@oracle.com, j-nomura@ce.jp.nec.com, "<Milan Broz" <mbroz@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Kiyoshi

>>> On 10/28/2008 at 09:30 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:=
=20
> Hi Nikanth,
>=20
> On Fri, 24 Oct 2008 13:14:50 +0530, "Nikanth K" wrote:
>> On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda wrote:
>> <snip>
>>=20
>> > +static int dm_make_request(struct request_queue *q, struct bio *bio=
)
>> > +{
>> > +       struct mapped_device *md =3D (struct mapped_device *)q->queu=
edata;
>> > +
>> > +       if (unlikely(bio_barrier(bio))) {
>> > +               bio_endio(bio, -EOPNOTSUPP);
>> > +               return 0;
>> > +       }
>> > +
>> <snip>
>>=20
>> Why not add barrier support in the beginning itself, so that targets
>> can be developed with barriers in mind? At least can we make the targe=
t
>> to return error, instead of the core?
>=20
> Currently, there is no barrier support in dm, not only request-based.
> Barrier support is a different feature in the next step, I think.
>=20

But there are some works in that direction to add support for barriers in=
 dm.
That is why I think building request-based dm with barriers from the=20
ground up might be a good idea.

> As you noticed in the PATCH#11, current request-based dm has
> the limitation that multiple targets are not supported, so it may
> look barrier support in request-based dm is easy.
> But we may be able to remove the limitation in the future, so
> depending on it is not a good idea.
>=20

Thanks
Nikanth Karthikesan
