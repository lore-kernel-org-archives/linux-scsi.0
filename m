From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 11/12] libsas: fix false positive 'device attached'
 conditions
Date: Sun, 22 Apr 2012 11:53:37 +0100
Message-ID: <1335092017.13208.15.camel@dabdike.lan>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	 <20120413233747.8025.13302.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120413233747.8025.13302.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-ide@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@intel.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
> Normalize phy->attached_sas_addr to return a zero-address in the case
> when device-type == NO_DEVICE or the linkrate is invalid to handle
> expanders that put non-zero sas addresses in the discovery response:
> 
>  sas: ex 5001b4da000f903f phy02:U:0 attached: 0100000000000000 (no device)
>  sas: ex 5001b4da000f903f phy01:U:0 attached: 0100000000000000 (no device)
>  sas: ex 5001b4da000f903f phy03:U:0 attached: 0100000000000000 (no device)
>  sas: ex 5001b4da000f903f phy00:U:0 attached: 0100000000000000 (no device)
> 
> Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

This should be flagged for stable, shouldn't it?

James


