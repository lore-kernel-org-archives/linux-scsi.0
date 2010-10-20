From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi: remove bogus use of struct execute_work in sg
Date: Wed, 20 Oct 2010 23:29:39 +0900
Message-ID: <20101020232322I.fujita.tomonori@lab.ntt.co.jp>
References: <4CBD95C0.6060302@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CBD95C0.6060302@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 19 Oct 2010 14:57:36 +0200
Tejun Heo <tj@kernel.org> wrote:

> execute_work usage in sg is bogus.  execute_in_process_context() is
> never used and ew is used purely as wrapper around work_struct which
> is superflous.  Use work_struct directly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/sg.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
