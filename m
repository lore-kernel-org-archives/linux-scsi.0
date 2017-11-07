From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: use timespec64 instead of timeval
Date: Tue, 7 Nov 2017 17:40:13 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A6941C525@avsrvexchmbx2.microsemi.net>
References: <20171107104613.3183755-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107104613.3183755-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> aacraid passes the current time to the firmware in one of two ways,
> either as year/month/day/... or as 32-bit unsigned seconds.
>=20
> The first one is broken on 32-bit architectures as it cannot
> go past year 2038. Using timespec64 here makes it behave properly
> on both 32-bit and 64-bit architectures, and avoids relying
> on signed integer overflow to pass times into the second interface.
>=20
> The interface used in aac_send_hosttime() however is still
> problematic in year 2106 when 32-bit seconds overflow. Hopefully
> we don't have to worry about aacraid by that time.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
