From: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Subject: Re: qla2300 at only 1 GBit on kernel 2.6.5
Date: Thu, 3 Jun 2004 22:23:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040603202328.GA1148@ii.uib.no>
References: <B179AE41C1147041AA1121F44614F0B0DD0114@AVEXCH02.qlogic.org> <20040505174649.GA21863@ii.uib.no> <87vfiptewv.fsf@frode.valhall.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S264263AbUFCUXi@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vfiptewv.fsf@frode.valhall.no>
To: =?iso-8859-1?Q?H=E5vard?= Lygre <hklygre@online.no>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 22, 2004 at 03:43:28AM +0200, H=E5vard Lygre wrote:
>=20
> Just as a datapoint: Vanilla Linux 2.6.6 gives me 2 Gbps with both
> sides set to auto.  This is with a QLogic 2312 (as sold by IBM). I
> haven't tried an earlier 2.6-series kernel on this computer.

Andrew Vasquez <andrew.vasquez@qlogic.com> found the problem. The 2.4
driver was forcing the data rate to auto negotiate, while the 2.6 (or
8.x series) driver was honouring the NVRAM setting which was at the
default 1 Gbps. Changing to auto negotiate in the qlogic BIOS fixed the
problem.

>=20
> On a side note: Your driver reports 33 MHz PCI - if this is in a
> 32-bit slot, isn't 2Gbps more than the bus can handle?

It's a 64 bit slot..


   -jf
