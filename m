From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM
 page pods for iSCSI
Date: Tue, 04 Jun 2019 20:17:41 -0700 (PDT)
Message-ID: <20190604.201741.2198584533127418560.davem@davemloft.net>
References: <1559643109-3397-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1559643109-3397-1-git-send-email-varun@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: varun@chelsio.com
Cc: netdev@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com, ganji.aravind@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>
Date: Tue,  4 Jun 2019 15:41:49 +0530

> +static int setup_ppod_edram(struct adapter *adap)
> +{
> +	int ret;
> +	unsigned int param, val;

Reverse christmas tree please.
