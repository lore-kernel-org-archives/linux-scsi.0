From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API &
 Library)
Date: Wed, 25 Jan 2012 12:42:24 -0500
Message-ID: <20120125174224.GA12620@infradead.org>
References: <4F19A981.4080502@redhat.com>
 <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com>
 <4F1D8913.1060709@redhat.com>
 <4F1FFF0F.1030007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54094
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429Ab2AYRm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 12:42:28 -0500
Content-Disposition: inline
In-Reply-To: <4F1FFF0F.1030007@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: tasleson@redhat.com, James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Wed, Jan 25, 2012 at 02:09:35PM +0100, Hannes Reinecke wrote:
> The various hardware vendors already have the means of managing their
> arrays, in most cases also providing a CLI.
> I would be hoping we could draft the API support such that we can
> use the existing tools, without the need of special plug-ins.

Wrapping tools from libraries is more of a last resort than a proper
solution.  But if we can't get better APIs that's probably what we
will have to resort to if vendors don't cooperate.

