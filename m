From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] [PATCH 2.6.9-rc1] add blacklist attribute indicating no ULD attach
Date: Wed, 15 Sep 2004 07:47:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915074744.A17264@infradead.org>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com> <20040915031834.GA102988@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:43531 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261711AbUIOGru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 02:47:50 -0400
Content-Disposition: inline
In-Reply-To: <20040915031834.GA102988@sgi.com>; from jeremy@sgi.com on Tue, Sep 14, 2004 at 08:18:34PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com, axboe@suse.de, james.bottomley@steeleye.com

On Tue, Sep 14, 2004 at 08:18:34PM -0700, Jeremy Higdon wrote:
>  	}
> +	else if (*bflags & BLIST_NO_ULD_ATTACH) {

Please put the else if on the same line as the closing brace

> +		sdev->no_uld_attach = 1;
> +	}

don't we already carry around the blacklist flags in the scsi dev so
they could be checked laer?  If not maybe we should instead of adding
more and more flags?

