From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: pcmcia: nsp_cs: remove module init/exit function
 prototypes
Date: Mon, 15 Apr 2013 10:20:57 -0700
Message-ID: <1366046457.6170.1.camel@dabdike>
References: <201304150942.37837.hsweeten@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201304150942.37837.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
To: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fengguang.wu@intel.com, yokota@netlab.is.tsukuba.ac.jp, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-04-15 at 09:42 -0700, H Hartley Sweeten wrote:
> This driver now uses the module_pcmcia_driver() macro to supply the
> init/exit code. The nsp_cs_{init,exit} prototypes should be removed.

This reasoning is bogus.

Why the driver actually has all these static prototypes in its header
file is entirely unclear to me, but singling these two out for the
reason you state above is wrong (both the reason and picking only two of
them).

Hiroshi, you're the maintainer, what do you want to do ... since the
driver is ancient, I'm happy to leave it untouched, or if you want to
tidy it up, I see no reason to have any static prototypes in the header
file.

Thanks,

James
