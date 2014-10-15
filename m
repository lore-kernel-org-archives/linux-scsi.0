From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net v2 0/4] ipv6 and related cleanup for cxgb4/cxgb4i
Date: Wed, 15 Oct 2014 00:30:48 -0400 (EDT)
Message-ID: <20141015.003048.958582830964017464.davem@davemloft.net>
References: <1413342444-16388-1-git-send-email-anish@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1413342444-16388-1-git-send-email-anish@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: anish@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org, jbottomley@parallels.com, kxie@chelsio.com, manojmalviya@chelsio.com, hariprasad@chelsio.com, leedom@chelsio.com, swise@opengridcomputing.com
List-Id: linux-scsi@vger.kernel.org

From: Anish Bhatt <anish@chelsio.com>
Date: Tue, 14 Oct 2014 20:07:20 -0700

> This patch set removes some duplicated/extraneous code from cxgb4i, guards
> cxgb4 against compilation failure based on ipv6 tristate, make ipv6 related
> code no longer be enabled by default irrespective of ipv6 tristate and fixes
> a refcnt issue.
> -Anish
> 
> v2 : Provide more detailed commit messages, make subject more concise as 
> recommended by Dave Miller.

Much better, series applied, thanks!
