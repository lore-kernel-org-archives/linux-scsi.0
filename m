From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Add 64-bit LUN support
Date: Tue, 10 Feb 2015 14:00:35 +0100
Message-ID: <1423573235.32606.11.camel@opteya.com>
References: <54CFB228.4070208@sandisk.com>
	 <1423556633.32606.7.camel@opteya.com> <54D9EE62.1010304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D9EE62.1010304-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

Le mardi 10 f=C3=A9vrier 2015 =C3=A0 12:41 +0100, Bart Van Assche a =C3=
=A9crit :
> On 02/10/15 11:13, Yann Droneaud wrote:
> > Le lundi 02 f=C3=A9vrier 2015 =C3=A0 18:21 +0100, Bart Van Assche a=
 =C3=A9crit :
> >> The largest LUN number that has been tested is 0xd2003fff00000000.
> >>
> >> Checked the following structure sizes with gdb:
> >> * sizeof(struct srp_cmd) =3D 48
> >> * sizeof(struct srp_tsk_mgmt) =3D 48
> >> * sizeof(struct srp_aer_req) =3D 36
> >=20
> > You can use 'pahole' tool to retrieve the size (and layout) of any
> > data structure from a .o object file.
>=20
> Thanks, I will have a look at that tool.
>=20
> >> The ibmvscsi changes have been compile tested only (on a PPC syste=
m).
> >=20
> > The changelog lack of any information about the purpose of 64bit LU=
Ns.
> > Please detail a bit why and how.
>=20
> You might have missed Hannes' patch series through which 64-bit LUN
> support was added in the SCSI core and in most SCSI LLD drivers.

Yes I've missed this thread, and, as this commit doesn't have a clear
reference to it, I feel I might not be alone wondering about it.

>  The
> description of one of the patches in that series reads as follows:
>=20
>    "The SCSI standard defines 64-bit values for LUNs, and large array=
s
>     employing large or hierarchical LUN numbers become more and more
>     common.
>=20
>     So update the linux SCSI stack to use 64-bit LUN numbers."
>=20
> Is it OK for you if I resend this patch with that text added in the
> patch description ?
>=20

That's would be perfect: it makes a lot more sense with these
information added. Additionally, you could add a link to the patch
series.

Thanks a lot.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
