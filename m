From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM
 page pods for iSCSI
Date: Mon, 10 Jun 2019 09:21:31 -0700 (PDT)
Message-ID: <20190610.092131.2236695647399216988.davem@davemloft.net>
References: <1560171994-9505-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1560171994-9505-1-git-send-email-varun@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: varun@chelsio.com
Cc: netdev@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com, ganji.aravind@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>
Date: Mon, 10 Jun 2019 18:36:34 +0530

> Page pods are used for direct data placement, this patch
> enables eDRAM page pods if firmware supports this feature.
> 
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>  v3: reordered local variable declarations in reverse christmas tree format
>  v2: fixed incorrect spelling of "contiguous"

Applied.
