From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: Sat, 22 Jun 2002 22:57:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206222247020.8911-100000@serv>
References: <3D14D9F1.8B88668F@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D14D9F1.8B88668F@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Roman Zippel <zippel@linux-m68k.org>, David Brownell <david-b@pacbell.net>, Nick Bellinger <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On Sat, 22 Jun 2002, Douglas Gilbert wrote:

> Trying to clear up the nomenclature here, according to SAM-2
> ( www.10.org ) target ports have mandatory "identifiers"
> and optional "names". The WWUI in iSCSI is part of the
> target _identifier_. SAM-2 is pretty vague about "names"
> but it does note that for a logical unit, its _name_
> may be reported in the Device Identification VPD page in
> an INQUIRY.

iSCSI currently specifies two types of names:
1. iSCSI Qualified Name: contains a date, domain and an arbitrary name,
   e.g. "iqn.2001-04.com.acme.diskarrays-sn-a8675309"
2. IEEE EUI-64 format: an IEEE assigned name, e.g.
   "eui.02004567A425678D"

bye, Roman

