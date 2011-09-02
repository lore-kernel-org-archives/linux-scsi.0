From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Date: Fri, 02 Sep 2011 21:51:54 +0900
Message-ID: <4E60D16A.8060802@hitachi.com>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com> <20110827102655.GJ2632@htj.dyndns.org>            <4E58E905.4020704@hitachi.com> <16628.1314734537@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16628.1314734537@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi Valdis,

(2011/08/31 5:02), Valdis.Kletnieks@vt.edu wrote:
> On Sat, 27 Aug 2011 21:54:29 +0900, Nao Nishijima said:
>=20
>> A kernel device names (e.g. sda) is not useful information because i=
t
>> doesn't always point the same disk at each boot-up time.
>=20
> If this is important to you, can't you use a udev rule, similar to wh=
at most
> distros already stick in 70-persistent-net.rules and 70-persistent-cd=
=2Erules?
>=20
> (Yes, this *does* involve finding a UUID or label or  something on th=
e disk
> that you can identify as "same entity as last time".

As you said, it is able to identify a disk at the expense of checking
cost. However to introduce "alias" is an advantage of reducing both the
cost and the risk of miss-communication, and it can easily identify it.

And also, currently, kernel log and command output do not accord with
the device name which a user uses (e.g. by-id, by-uuid). I would try to
solve those mismatches using "alias". In other words, I'd like to
introduce aliases for integrating the name of devices to control and re=
cord.

Of course I will modify commands using a device name to use a persisten=
t
device names.


Best regards,

--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
