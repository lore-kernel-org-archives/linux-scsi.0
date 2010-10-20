From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] scsi: remove bogus use of struct execute_work in
 sg
Date: Wed, 20 Oct 2010 21:56:13 +0200
Message-ID: <4CBF495D.3090606@interlog.com>
References: <4CBD95C0.6060302@kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CBD95C0.6060302@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10-10-19 02:57 PM, Tejun Heo wrote:
> execute_work usage in sg is bogus.  execute_in_process_context() is
> never used and ew is used purely as wrapper around work_struct which
> is superflous.  Use work_struct directly.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
