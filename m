From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch -resend] [SCSI] isci: add a couple __iomem annotations
Date: Wed, 27 Jun 2012 13:58:06 -0700
Message-ID: <CABE8wwt-56EzC4Tmh8FyGPS+ftgNz3EAh7qfRxpc9CZizOqQqQ@mail.gmail.com>
References: <20120627085800.GA3007@mwanda>
	<20120627090521.GM31212@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120627090521.GM31212@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 27, 2012 at 2:05 AM, Dan Carpenter <dan.carpenter@oracle.co=
m> wrote:
> These are __iomem. =A0Sparse complains if we don't have that.
>
> drivers/scsi/isci/phy.c +149 70: warning:
> =A0 =A0 =A0 =A0incorrect type in initializer (different address space=
s)
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Sent on Wed, 18 Jan 2012.
>

Thanks for nudge, this fell off the radar.  I'll get this into -next
with the rest of the pending bits.
