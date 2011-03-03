From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cxgb{3,4}*: improve Kconfig dependencies
Date: Wed, 02 Mar 2011 22:23:08 -0800 (PST)
Message-ID: <20110302.222308.102540229.davem@davemloft.net>
References: <1298950455-4497-1-git-send-email-dm@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1298950455-4497-1-git-send-email-dm@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: dm@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, JBeulich@novell.com
List-Id: linux-scsi@vger.kernel.org

From: Dimitris Michailidis <dm@chelsio.com>
Date: Mon, 28 Feb 2011 19:34:15 -0800

> - Remove the dependency of cxgb4 and cxgb4vf on INET.  cxgb3 really
>   depends on INET, keep it but add it directly to the driver's Kconfig
>   entry.
> - Make the iSCSI drivers cxgb3i and cxgb4i available in the SCSI menu
>   without requiring any options in the net driver menu to be enabled
>   first.  Add needed selects so the iSCSI drivers can build their
>   corresponding net drivers.
> - Remove CHELSIO_T*_DEPENDS.
> 
> Signed-off-by: Dimitris Michailidis <dm@chelsio.com>

Applied to net-next-2.6, thanks!
