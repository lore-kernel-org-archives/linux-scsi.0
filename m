From: Tony Luck <tony.luck@gmail.com>
Subject: Re: scsi scan: INQUIRY result too short (5), using 36
Date: Wed, 24 Jul 2013 13:14:31 -0700
Message-ID: <CA+8MBbL+GqQQ8-_=D=qOVj9qa1RebtmaF9spHR6NcHMTPrQpFw@mail.gmail.com>
References: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
	<1374694998.7382.33.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374694998.7382.33.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 24, 2013 at 12:43 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Oops, apparently no-one I cc'd at intel actually bothered to check the
> patch for the isci driver.  The looks to be that sci_swab32_cpy needs
> multiples of four, so for commands that aren't that, it's rounding the
> wrong way.  Does this fix it?

Yes. That fixes it.

Wrap whichever of:

Reported-by: Tony Luck <tony.luck@intel.com>

and/or

Tested-by: Tony Luck <tony.luck@intel.com>

around that patch and ship it!

Thanks for the fast fix.

-Tony
