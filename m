From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] mpt2sas: don't handle broadcast primitives
Date: Fri, 19 Jul 2013 18:11:43 -0400
Message-ID: <20130719221143.GG29404@logfs.org>
References: <20130719220659.GF29404@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130719220659.GF29404@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mit@purestorage.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 19 July 2013 18:06:59 -0400, J=C3=B6rn Engel wrote:
>=20
> The handling of broadcast primitives involves
> _scsih_block_io_all_device(), which does what the name implies.  I ha=
ve
> observed cases with >60s of blocking io on all devices, caused by a
> single bad device.  The downsides of this code are obvious, while the
> upsides are more elusive.

And since this patch looks more like an April fools joke: I have
gathered a few machine-months of testing, including tortures that
specifically stress the removed codepaths.  This is a serious
submission and unless someone can show me a _very_ good reason for
keeping the deleted code, I would like to get it merged.

J=C3=B6rn

--
Computer system analysis is like child-rearing; you can do grievous dam=
age,
but you cannot ensure success."
-- Tom DeMarco
