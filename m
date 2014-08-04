From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH V3 1/4] Add XEN pvSCSI protocol
 description
Date: Mon, 04 Aug 2014 11:10:17 +0100
Message-ID: <53DF78290200007800028E39@mail.emea.novell.com>
References: <1407140870-542-1-git-send-email-jgross@suse.com>
 <1407140870-542-2-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.emea.novell.com ([130.57.118.101]:60750 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaHDKKX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:7:1>);
	Mon, 4 Aug 2014 06:10:23 -0400
In-Reply-To: <1407140870-542-2-git-send-email-jgross@suse.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <JGross@suse.com>
Cc: david.vrabel@citrix.com, hch@infradead.org, xen-devel@lists.xen.org, konrad.wilk@oracle.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

>>> On 04.08.14 at 10:27, <JGross@suse.com> wrote:
> +/* Requests from the frontend to the backend */
> +
> +/*
> + * Request a SCSI operation specified via a CDB in vscsiif_request.cmnd.
> + * The target is specified via channel, id and lun.
> + */
> +#define VSCSIIF_ACT_SCSI_CDB		1
> +
> +/*
> + * Request abort of a running operation for the specified target given by
> + * channel, id, lun and the operation's rqid in ref_rqid.
> + */
> +#define VSCSIIF_ACT_SCSI_ABORT		2
> +
> +/*
> + * Request a device reset of the specified target (channel and id).
> + */
> +#define VSCSIIF_ACT_SCSI_RESET		3

While I realize you don't want to support it, leaving out
VSCSIIF_ACT_SCSI_SG_PRESET altogether from this header may
lead people to the false impression that its number is available for
other use. I would generally recommend the Linux headers to not
deviate from the master ones more than absolutely necessary,
keeping what isn't needed/wanted by Linux at least in commented
out form.

Jan

