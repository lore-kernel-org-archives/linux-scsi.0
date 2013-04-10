From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: checkpatch: kill the bogus camelcase check
Date: Wed, 10 Apr 2013 08:07:41 -0700
Message-ID: <1365606461.1942.3.camel@dabdike>
References: <1365544254.2946.53.camel@dabdike> <20130410132628.GV7511@dm>
	 <1365604558.27174.36.camel@joe-AO722> <20130410145213.GA6854@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130410145213.GA6854@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-04-10 at 16:52 +0200, Borislav Petkov wrote:
> On Wed, Apr 10, 2013 at 07:35:58AM -0700, Joe Perches wrote:
> > or maybe exclude drivers/scsi and include/scsi/
> 
> and arch/x86/kvm/emulate.c

Actually, we get this all over drivers.  Some of the problems are to do
with the fact that the check is wrong, so it thinks things like this

drm_core_has_MTRR

are studly caps when they're not, but we have a lot of device
programming manual driven studly caps in PCI, ata, ide etc ..

We also have sanctioned use in mm, things like:

SetPageReserved
ClearPageReserved

But the point still stands.  When checkpatch warns about this, there's
nothing that the person submitting the patch can do because the usage
was already embedded into the file they're patching.

James
