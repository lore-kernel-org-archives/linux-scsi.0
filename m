From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [SCSI] sr: sr_mutex ,multi-drive performance is bad
Date: Tue, 29 Oct 2013 08:53:58 -0600
Message-ID: <526FCC06.6070908@kernel.dk>
References: <CAO4Pk4wxUN-O_m5KcdZgmTTRG2w8icqva+0dxu7HRO=rEpbArg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J2OyC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 10:54:02 -0400
In-Reply-To: <CAO4Pk4wxUN-O_m5KcdZgmTTRG2w8icqva+0dxu7HRO=rEpbArg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yang jun <yangjun.donglife123@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/28/2013 08:30 AM, yang jun wrote:
> Dear Mr.Axboe,
>=20
> The latest kernel sr_module still uses single mutex,it will serialise
> all sr ioctls. Otto Meta had mentioned this on Jan 1st, 2013 . Some
> record tools such as growisofs use SG_IO to write data to disc, so if
> there are multiple cdroms being recorded at the same time=A3=ACit wil=
l be
> very slowly.
>=20
> I saw sd_module before,it had removed BKL and made "openers" atomic_t
> in scsi_disk. Shall we do the same thing to sr_module? That is, to
> remove sr_mutex and make "use_count" atomic_t in cdrom_device_info.

The same conversion that happened to sd could apply to sr just as easil=
y.

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
