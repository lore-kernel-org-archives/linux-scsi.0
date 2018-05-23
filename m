From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] cxgb4: change the port capability bits
 definition
Date: Wed, 23 May 2018 16:01:07 -0400 (EDT)
Message-ID: <20180523.160107.278879995651890420.davem@davemloft.net>
References: <1527085978-9859-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527085978-9859-1-git-send-email-ganeshgr@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: ganeshgr@chelsio.com
Cc: netdev@vger.kernel.org, nirranjan@chelsio.com, indranil@chelsio.com, venkatesh@chelsio.com, linux-scsi@vger.kernel.org, varun@chelsio.com, leedom@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Ganesh Goudar <ganeshgr@chelsio.com>
Date: Wed, 23 May 2018 20:02:58 +0530

> MDI Port Capabilities bit definitions were inconsistent with
> regard to the MDI enum values. 2 bits used to define MDI in
> the port capabilities are not really separable, it's a 2-bit
> field with 4 different values. Change the port capability bit
> definitions to be "AUTO" and "STRAIGHT" in order to get them
> to line up with the enum's.
> 
> Signed-off-by: Casey Leedom <leedom@chelsio.com>
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>

Applied.
