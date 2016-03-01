From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 12/34] cxgb4: update Kconfig and Makefile
Date: Tue, 1 Mar 2016 06:47:06 -0800
Message-ID: <20160301144706.GA9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <3047de46b89ddbe92b6125f773e8149bde59f8a1.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3047de46b89ddbe92b6125f773e8149bde59f8a1.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, davem@davemloft.net, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

> +config CHELSIO_T4_UWIRE
> +	bool "Unified Wire Support for Chelsio T5 cards"
> +	default n
> +	depends on CHELSIO_T4
> +	---help---
> +	  Enable unified-wire offload features.
> +	  Say Y here if you want to enable unified-wire over Ethernet
> +	  in the driver.

And what the hell is "unified-wire over Ethernet".  A little more
explanation would be very helpful for the user facing this question.
