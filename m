From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix handling of small allocation lengths in
 REPORT LUNS
Date: Thu, 13 Aug 2015 16:23:04 -0700
Message-ID: <1439508184.31978.57.camel@haakon3.risingtidesystems.com>
References: <1439445958-24753-1-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1439445958-24753-1-git-send-email-sbaugh@catern.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Hi Spencer & Co,

On Wed, 2015-08-12 at 23:05 -0700, Spencer Baugh wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> REPORT LUNS should not fail just because the allocation length is less
> than 16.  The relevant section of SPC-4 is:
> 
>   4.2.5.6 Allocation length
> 
>   The ALLOCATION LENGTH field specifies the maximum number of bytes or
>   blocks that an application client has allocated in the Data-In
>   Buffer. The ALLOCATION LENGTH field specifies bytes unless a
>   different requirement is stated in the command definition.
> 
>   An allocation length of zero specifies that no data shall be
>   transferred. This condition shall not be considered an error.
> 
> So we should just truncate our response rather than return an error.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>

This patch looks fine, but it currently doesn't apply to
target-pending/master code due Roland's earlier patch:

target: REPORT LUNS should return LUN 0 even for dynamic ACLs
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=9c395170a559d3b23dad100b01fc4a89d661c698

Would you be so kind to respin atop current target-pending/master..?

Thank you,

--nab
