From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] csiostor:firmware upgrade fix
Date: Thu, 08 Jan 2015 20:12:50 -0800 (PST)
Message-ID: <20150108.201250.705102211192388649.davem@davemloft.net>
References: <1420638388-9074-1-git-send-email-praveenm@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1420638388-9074-1-git-send-email-praveenm@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: praveenm@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@infradead.org, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Praveen Madhavan <praveenm@chelsio.com>
Date: Wed,  7 Jan 2015 19:16:28 +0530

> This patch fixes removes older means of upgrading Firmware using MAJOR version
> and adds newer interface version checking mechanism.
> 
> Please apply this patch on net-next since it depends on previous commits.
> 
> Signed-off-by: Praveen Madhavan <praveenm@chelsio.com>

Applied.
