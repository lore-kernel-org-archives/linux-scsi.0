From: adam radford <aradford@gmail.com>
Subject: Re: 3w-sas 0000:02:00.0: vpd r/w failed.
Date: Wed, 26 Jan 2011 12:46:46 -0800
Message-ID: <AANLkTi=qAfFTqhaFO+n0gxtr2e_YeZpQ20RVeeHCrpPL@mail.gmail.com>
References: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
	<AANLkTikECrLeVGQt6ui0eHVdohgtW7-ksetrsKp4sRNw@mail.gmail.com>
	<alpine.DEB.2.00.1101261534460.13169@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101261534460.13169@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2011 at 12:40 PM, Justin Piszcz <jpiszcz@lucidpixels.co=
m> wrote:
>
>
> Does the driver require some combination of those options to be enabl=
ed? Or
> does the 3ware card need a firmware update? =A0What is the recommende=
d fix?

Your config looks okay.  I remember you having some issues turning on
those config options in the past.

Perhaps under certain conditions occasionally the card cannot respond
in the default timeout period:

        unsigned long timeout =3D jiffies + HZ/20 + 2;

-Adam
