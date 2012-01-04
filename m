From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [50/75] mpt2sas crashes on shutdown
Date: Wed, 04 Jan 2012 09:19:58 -0600
Message-ID: <1325690398.2758.10.camel@dabdike.int.hansenpartnership.com>
References: <20120103223332.GA4112@kroah.com>
	 <20120103223325.206012007@clark.kroah.org>
	 <A6888A6805518E4EA4AF7072A28264A60481D5AAEC@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A60481D5AAEC@inbmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Greg KH <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-01-04 at 14:23 +0530, Nandigama, Nagalakshmi wrote:
> Greg,
> As a fix to this issue, I posted the patch "[PATCH] mpt2sas: Remove
> msix_table_backup which is required only for preproduction boards".
> The patch in this mail will not address the complete issue. 
> 
> Please revert back this patch and add the patch "[PATCH] mpt2sas:
> Remove msix_table_backup which is required only for preproduction
> boards" to the stable kernels 3.0 and 3.1.

So the problem is that you still haven't actually manage to produce a
patch for the problem in the form required by the stable tree as listed
in 

Documentation/stable_kernel_rules.txt

If you can't follow the guide, perhaps an example would work, so as a
one time thing, I'll show you what such a patch should look like
according to the rules of the stable kernel in reply to this email

James
