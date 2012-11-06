From: Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Date: Tue, 06 Nov 2012 15:55:49 -0500
Message-ID: <50997955.10000@gmail.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>  <1352145183-29355-3-git-send-email-xi.wang@gmail.com> <1352203618.2529.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352203618.2529.22.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/6/12 7:06 AM, James Bottomley wrote:
>
> Why is this necessary?  As I read the reg set assignment code, it finds
> a free bit in the 64 bit register and uses that ... which can never be
> greater than 64 so there's no need for the check.

This patch just tries to be more defensive for bit(reg_set) with a
broken reg_set value.  I agree with you that it's not that necessary.

> The other two look OK (probably redone as a single patch with a stable
> tag), but I'd like the input of the mvs people since it seems with the
> current code, we only use 32 bit regsets and probably hang if we go over
> that.  The bug fix is either to enable the full 64 if it works, or
> possibly cap at 32 ... what works with all released devices?

Thanks for reviewing.  Yeah we'd better to wait for the input from
the mvs people.

- xi
