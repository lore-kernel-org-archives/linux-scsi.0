From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] fdomain: Resurrect driver (core)
Date: Mon, 29 Apr 2019 13:32:37 -0700
Message-ID: <20190429203237.GA19699@infradead.org>
References: <20190428200626.28092-1-linux@zary.sk>
 <20190428200626.28092-2-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190428200626.28092-2-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +void fdomain_reset(int base)

Should be marked static.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
