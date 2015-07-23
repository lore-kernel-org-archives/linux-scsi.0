From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: respond to unknown initiators with sensible
 REPORT LUNS list length
Date: Thu, 23 Jul 2015 02:41:09 -0700
Message-ID: <20150723094109.GF5382@infradead.org>
References: <1437602898-15229-3-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437602898-15229-3-git-send-email-sbaugh@catern.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 22, 2015 at 03:08:17PM -0700, Spencer Baugh wrote:
>  done:
> +	/*
> +	 * If no real LUNs are accessible, report an allocation length
> +	 * of 1 LUN to account for virtual LUN 0.
> +	 */
> +	if (lun_count == 0)
> +		lun_count = 1;
> +

Shouldn't the code actually report the virtual lun zero instead of just
accounting for it?
