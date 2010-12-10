From: Greg KH <greg@kroah.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 10 Dec 2010 11:36:37 -0800
Message-ID: <20101210193637.GA23113@kroah.com>
References: <20101115161620.GB5981@kroah.com>
 <4CE16B8E.1000300@panasas.com>
 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
 <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com>
 <4CE2846C.6070501@vlnb.net>
 <4CE59482.3050002@gmail.com>
 <20101118214619.GA29097@kroah.com>
 <4CE6BB4A.5060606@gmail.com>
 <20101119211904.GB28606@kroah.com>
 <AANLkTimJo_ZtQ3uVEBv864pP9f9AZR3D_o0R7T-B3fWL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimJo_ZtQ3uVEBv864pP9f9AZR3D_o0R7T-B3fWL@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vvvvvst@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 10, 2010 at 01:06:06PM +0100, Bart Van Assche wrote:
> On Fri, Nov 19, 2010 at 10:19 PM, Greg KH <greg@kroah.com> wrote:
> > [ ... ]
> >
> > None. =A0Use 'struct device'
>=20
> How about using 'struct device' as follows ?
> * Move /sys/kernel/scst_tgt/targets to /sys/class/target_driver.

Please never create a new class, use 'struct bus_type' instead and
create a bus and have drivers and devices on it.

thanks,

greg k-h
