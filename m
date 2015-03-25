From: Joerg Roedel <joro@8bytes.org>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Wed, 25 Mar 2015 14:59:37 +0100
Message-ID: <20150325135937.GR4441@8bytes.org>
References: <54E1FFFA.1060403@compro.net>
 <54F60D33.8090401@compro.net>
 <20150323150304.GQ4441@8bytes.org>
 <5511513D.6090106@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5511513D.6090106@compro.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Hounschell <markh@compro.net>
Cc: "linux-scsi@vger.kernel.org >> SCSI development list" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 24, 2015 at 07:57:49AM -0400, Mark Hounschell wrote:
> I'll be happy to test it.

Okay, here you go:

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux.git amd-iommu

This branch has two patches on-top of v4.0-rc5 which should fix the
issue you described here. Please let me know if it works for you.


	Joerg
