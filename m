From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.4.25-pre7 SCSI fusion driver - version - 2.05.11.01
Date: Tue, 27 Jan 2004 23:19:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040127231957.A21852@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19EE4@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:48646 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264284AbUA0XT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 18:19:58 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703D19EE4@exa-atlanta.se.lsil.com>; from Emoore@lsil.com on Tue, Jan 27, 2004 at 06:04:34PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, marcelo.tosatti@cyclades.com

On Tue, Jan 27, 2004 at 06:04:34PM -0500, Moore, Eric Dean wrote:
> +
> +#if (defined(__sparc__) && defined(__sparc_v9__)) || defined(__x86_64__) ||
> defined(__ia64__) || defined(__alpha__)
> +#define MPT_CONFIG_COMPAT
> +#endif

alpha doesn't have any 32bit userland..

