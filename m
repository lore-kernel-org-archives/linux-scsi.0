From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 08:07:14 +0100
Message-ID: <20060613070714.GA16358@infradead.org>
References: <448DF5DA.3070800@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24011 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932941AbWFMHHQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 03:07:16 -0400
Content-Disposition: inline
In-Reply-To: <448DF5DA.3070800@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James.Smart@Emulex.Com, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

On Mon, Jun 12, 2006 at 06:16:42PM -0500, Michael Reed wrote:
> If the fc transport removes the scsi infrastructure for a
> disconnected target and that target subsequently returns,
> those subsystems layered upon scsi which don't understand
> the implications of this disconnection / reconnection may
> be unable to access the reconnected scsi target.  This patch
> makes the target removal configurable.

NACK, we don't want to keep dead targets around.

