From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 15:55:42 +0100
Message-ID: <20090716145542.GA14691@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de> <20090716143828.GB13924@srcf.ucam.org> <1247755399.6606.4.camel@mulgrave.site> <20090716144536.GB14345@srcf.ucam.org> <1247756009.6606.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1247756009.6606.9.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 16, 2009 at 02:53:29PM +0000, James Bottomley wrote:

> Well, a flag that says 'hotplug' and means both the controller and bus
> support hotplugging might be SCSI specific.  However, the fact is that
> most people make such a determination on the bus type, so it's a bit
> redundant (in true SCSI there really is no controller on a hotplug bus
> that doesn't support hotplug because they can't scan the bus without
> it).  If you intend to use it to make link power management decisions,
> that's completely different because SAS PM support still isn't
> standardised and most of the rest of SCSI doesn't have it either.  So it
> sounds to me you're looking for a flag that says "might have a problem
> with SATA link power management" ... in which case this is currently
> libata specific.  We might be able to expand it to libsas if (when) we
> actually get link power management standardised, but a lot of the other
> busses aren't even going to have a concept of link power management.

Makes sense. I'll respin it as a libata feature.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
