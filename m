From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [V2 PATCH 6/9] csiostor: Chelsio FCoE offload driver submission
 (headers part 1).
Date: Wed, 5 Sep 2012 09:33:05 -0700
Message-ID: <20120905093305.2418eac8@nehalam.linuxnetplumber.net>
References: <1346848442-4573-1-git-send-email-naresh@chelsio.com>
	<1346848442-4573-7-git-send-email-naresh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1346848442-4573-7-git-send-email-naresh@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Naresh Kumar Inna <naresh@chelsio.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, dm@chelsio.com, leedom@chelsio.com, netdev@vger.kernel.org, chethan@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Wed,  5 Sep 2012 18:03:59 +0530
Naresh Kumar Inna <naresh@chelsio.com> wrote:

> +
> +#define	CSIO_ASSERT(cond)						\
> +do {									\
> +	if (unlikely(!((cond))))					\
> +		BUG();                                                  \
> +} while (0)
> +

Why is this not just BUG_ON(!(cond)) ?
