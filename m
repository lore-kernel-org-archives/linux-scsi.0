From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/3] scsi: drop unlikely behind BUG_ON()
Date: Sun, 4 Oct 2015 07:33:29 -0700
Message-ID: <561138B9.6060004@sandisk.com>
References: <a89c7bef0699c3d3f5e592c58ff3f0a4db482b69.1443937856.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a89c7bef0699c3d3f5e592c58ff3f0a4db482b69.1443937856.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/03/15 23:18, Geliang Tang wrote:
> BUG_ON() already contain an unlikely compiler flag. Drop it.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
