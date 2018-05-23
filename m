From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] cxgb4: do L1 config when module is
 inserted
Date: Wed, 23 May 2018 16:01:13 -0400 (EDT)
Message-ID: <20180523.160113.1204214799750713864.davem@davemloft.net>
References: <1527086013-9904-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527086013-9904-1-git-send-email-ganeshgr@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: ganeshgr@chelsio.com
Cc: netdev@vger.kernel.org, nirranjan@chelsio.com, indranil@chelsio.com, venkatesh@chelsio.com, linux-scsi@vger.kernel.org, varun@chelsio.com, leedom@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Ganesh Goudar <ganeshgr@chelsio.com>
Date: Wed, 23 May 2018 20:03:33 +0530

> trigger an L1 configure operation when a transceiver module
> is inserted in order to cause current "sticky" options like
> Requested Forward Error Correction to be reapplied.
> 
> Signed-off-by: Casey Leedom <leedom@chelsio.com>
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>

Applied.
