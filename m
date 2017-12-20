From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] qed*: Utilize FW 8.33.1.0
Date: Wed, 20 Dec 2017 11:54:03 -0500 (EST)
Message-ID: <20171220.115403.2203972051867900874.davem@davemloft.net>
References: <1513692323-26684-1-git-send-email-Tomer.Tayar@cavium.com>
        <20171219154651.30930d2a@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171219154651.30930d2a@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
To: jakub.kicinski@netronome.com
Cc: Tomer.Tayar@cavium.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Ariel.Elior@cavium.com, Michal.Kalderon@cavium.com, Yuval.Bason@cavium.com, Ram.Amrani@cavium.com, Manish.Chopra@cavium.com, Chad.Dupuis@cavium.com, Manish.Rangankar@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 19 Dec 2017 15:46:51 -0800

> On Tue, 19 Dec 2017 16:05:23 +0200, Tomer Tayar wrote:
>> Sorry for the very long patch.
>> The firmware changes are spread all over w/o a good modularity.
> 
> Rings false.  Significant portion of this patch is just whitespace 
> and comment changes.

Totally agreed.

This thing is beyond huge already, adding unrelated whitespace and
comment changes make reviewing it even more impossible.
