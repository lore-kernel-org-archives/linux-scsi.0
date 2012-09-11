From: David Miller <davem@davemloft.net>
Subject: Re: [V3 PATCH 9/9] cxgb4vf: Chelsio FCoE offload driver submission
 (header compatibility fixes).
Date: Tue, 11 Sep 2012 13:33:21 -0400 (EDT)
Message-ID: <20120911.133321.282568248903907762.davem@davemloft.net>
References: <1347374347-3852-1-git-send-email-naresh@chelsio.com>
	<1347374347-3852-10-git-send-email-naresh@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1347374347-3852-10-git-send-email-naresh@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: naresh@chelsio.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, dm@chelsio.com, leedom@chelsio.com, netdev@vger.kernel.org, chethan@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Naresh Kumar Inna <naresh@chelsio.com>
Date: Tue, 11 Sep 2012 20:09:07 +0530

> This patch contains minor fixes to make cxgb4vf driver work with the updates to
> shared firmware/hardware header files.
> 
> Signed-off-by: Naresh Kumar Inna <naresh@chelsio.com>

You cannot submit a patch set that isn't bisectable, and in particular
create a situation that mid-way through your patch set things do not
build or operate correctly.
