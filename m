From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [dm-devel] Re: [ANNOUNCE] multipath-tools-0.3.4
Date: Tue, 26 Oct 2004 10:52:25 -0700
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <417E8ED9.7070506@us.ibm.com>
References: <1096071849.4466.31.camel@zezette>	<1097054573.4163b96d1262c@imp5-q.free.fr>	<1097495416.416a73787e0ae@imp1-q.free.fr>	<1098021787.5433.8.camel@zezette>	<1098269169.417641f18a234@imp1-q.free.fr>	<1098656088.9350.88.camel@zezette>	<1098692559.2798.7.camel@laptop.fenrus.org>	<1098697123.417cc9a3b5bc5@imp1-q.free.fr> <20041025210304.GH3714@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <20041025210304.GH3714@marowsky-bree.de>
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: device-mapper development <dm-devel@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Lars Marowsky-Bree wrote:

> On 2004-10-25T11:38:43, christophe.varoqui@free.fr wrote:
>=20
>=20
>>In fact all the sg stuff I use is done with the SG_IO ioctl (see
>>libcheckers/*.c) But somehow, it doesn't work as expected. I don't
>>remember how exactly it failed in my tests but it did ... I remembered
>>receiving bad path status and experiencing blocked checkers.
>=20
>=20
> Can you please clarify the error you saw? I didn't experience that yet
> with the SG_IO ioctl().
>=20

I think it was because of this bug
http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D108617935710955&w=3D2

If you are using qla2xxx and you unplug the cable, the qlogic driver
will return did_not_connect in the host byte. If you used
the block layer sg io code you will then not get the host bytes
returned to you, and the checker will always think the patch
is back up.


> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>=20



-------------------------------------------------------
This SF.Net email is sponsored by:
Sybase ASE Linux Express Edition - download now for FREE
LinuxWorld Reader's Choice Award Winner for best database on Linux.
http://ads.osdn.com/?ad_id=5588&alloc_id=12065&op=click
