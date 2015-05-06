From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] libsas: Kconfig: Enable SATA compatibility by
 default
Date: Wed, 06 May 2015 07:23:30 -0700
Message-ID: <1430922210.2173.157.camel@HansenPartnership.com>
References: <21826.14993.432271.52216@mariner.uk.xensource.com>
	 <1430490978-1091-1-git-send-email-ian.jackson@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430490978-1091-1-git-send-email-ian.jackson@eu.citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ian Jackson <ian.jackson@eu.citrix.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, James Bottomley <James.Bottomley@suse.de>, Donald D Dugger <donald.d.dugger@intel.com>, Pawel Baldysiak <pawel.baldysiak@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Ian Campbell <ian.campbell@citrix.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-01 at 15:36 +0100, Ian Jackson wrote:
> SATA controllers support SATA disks.  The kernel should be able to
> drive these, by default.  It should not silently (apart from a
> debugging-only printk) ignore them.

To be honest, this is a bit pointless: no distribution takes the kernel
defaults anyway so changing it achieves nothing.

The original thought behind doing this is that libata was huge and is
pulled in by the sata code whether its actually used or not.  Certain
configurations might not want this.  However, I think we can all agree
that the major SAS user is enterprise and for them, kernel size isn't
usually a huge worry.  Even for enterprise, the predominant
configuration seems to be SAS expanders with SATA drives, so they can't
turn it off anyway.  Therefore a more useful question might be: is it
time to remove the option entirely?

James
