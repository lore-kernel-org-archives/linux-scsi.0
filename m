From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] megaraid: convert to work_struct
Date: Tue, 18 Dec 2012 08:59:32 -0800
Message-ID: <20121218165932.GK1844@htj.dyndns.org>
References: <1355388798-12869-1-git-send-email-xtfeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355388798-12869-1-git-send-email-xtfeng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 13, 2012 at 04:53:18PM +0800, Xiaotian Feng wrote:
> There's no need to use delayed work, convert to use work_struct and
> cancel_work_sync().
> 
> Requested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
