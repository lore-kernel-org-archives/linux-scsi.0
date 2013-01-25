From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] mpt2sas: prevent double free on error path
Date: Fri, 25 Jan 2013 12:12:55 -0500
Message-ID: <20130125171255.GA22141@logfs.org>
References: <20130123212033.GA15800@logfs.org>
 <87k3r310jr.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k3r310jr.fsf@nemi.mork.no>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 January 2013 08:51:20 +0100, Bj=C3=B8rn Mork wrote:
>=20
> How about the copy of this code in drivers/scsi/mpt3sas/mpt3sas_scsih=
=2Ec?
> Is that safe, or does it need fixing as well?

Well spotted, that appears to suffer from the same ailment.  Will cook
up a second patch for that.

Are there any other copies of this code around?

J=C3=B6rn

--
The object-oriented version of 'Spaghetti code' is, of course, 'Lasagna=
 code'.
(Too many layers).
-- Roberto Waltman.
