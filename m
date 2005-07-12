From: Amrut Joshi <amrut.joshi@gmail.com>
Subject: Re: SCSI luns
Date: Tue, 12 Jul 2005 17:25:20 +0530
Message-ID: <1ba727770507120455789aaf0a@mail.gmail.com>
References: <1ba727770507120422562d525d@mail.gmail.com>
	 <1121168331.3171.21.camel@laptopd505.fenrus.org>
Reply-To: Amrut Joshi <amrut.joshi@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10928_30197528.1121169320825"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.206]:11375 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261368AbVGLL4X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 07:56:23 -0400
Received: by wproxy.gmail.com with SMTP id i7so1088541wra
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 04:56:23 -0700 (PDT)
In-Reply-To: <1121168331.3171.21.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

------=_Part_10928_30197528.1121169320825
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On 7/12/05, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 2005-07-12 at 16:52 +0530, Amrut Joshi wrote:
> > Hi,
> >
> > Currently linux scsi subsystem doesnt store the 8-byte luns which are
> > recieved in REPORT_LUNS reply. This information is forver lost once
> > the scan is over. In my LDD  I need this information. Currently I have
> > to snoop REPORT_LUNS reply, do scsilun_to_int for all the luns and
>=20
> which LDD is this? Is it ready for merging into the linux kernel yet?
>=20

It will be ready for submission in a couple of months. The design (and
implementation) would be simplified if these changes are accepted. Any
thoughts?

Sorry for the garbled patch. Attaching it again.=20

Please CC me on the replies.

Thanks,
-Amrut!

------=_Part_10928_30197528.1121169320825
Content-Type: application/octet-stream; name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch"

LS0tIGRyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYy5vcmlnCTIwMDUtMDYtMzAgMDQ6MzA6NTMuMDAw
MDAwMDAwICswNTMwCisrKyBkcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmMJMjAwNS0wNy0xMiAxNjox
OTo0OC41MzM3ODg1MjggKzA1MzAKQEAgLTExNzAsNiArMTE3MCw3IEBACiAJCQkJICAgICAgICIg
YWJvcnRlZFxuIiwgZGV2bmFtZSwgbHVuKTsKIAkJCQlicmVhazsKIAkJCX0KKyAgICAgICAgICAg
ICAgICAgICAgICAgIG1lbWNweShzZGV2LT5sdW5fYWRkcmVzcywgbHVucCwgc2l6ZW9mKHNkZXYt
Pmx1bl9hZGRyZXNzKSk7CiAJCX0KIAl9CiAKLS0tIGluY2x1ZGUvc2NzaS9zY3NpX2RldmljZS5o
Lm9yaWcJMjAwNS0wNi0zMCAwNDozMDo1My4wMDAwMDAwMDAgKzA1MzAKKysrIGluY2x1ZGUvc2Nz
aS9zY3NpX2RldmljZS5oCTIwMDUtMDctMTIgMTY6MTk6NDguNTM0Nzg4Mzc2ICswNTMwCkBAIC01
OCw2ICs1OCw4IEBACiAJCQkJCSAgIGNvdWxkIGFsbCBiZSBmcm9tIHRoZSBzYW1lIGV2ZW50LiAq
LwogCiAJdW5zaWduZWQgaW50IGlkLCBsdW4sIGNoYW5uZWw7CisgICAgICAgIHN0cnVjdCBzY3Np
X2x1biBsdW5fYWRkcmVzczsgICAgLyogc2NzaSBhZGRyZXNzIHJldHVybmVkIGJ5IFJFUE9SVF9M
VU5TCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogdXNhYmxlIG9u
bHkgaWYgc2Rldi0+c2NzaV9sdW4gPj0gU0NTSV8zICovCiAKIAl1bnNpZ25lZCBpbnQgbWFudWZh
Y3R1cmVyOwkvKiBNYW51ZmFjdHVyZXIgb2YgZGV2aWNlLCBmb3IgdXNpbmcgCiAJCQkJCSAqIHZl
bmRvci1zcGVjaWZpYyBjbWQncyAqLwo=
------=_Part_10928_30197528.1121169320825--
