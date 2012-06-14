From: Jens Axboe <axboe@kernel.dk>
Subject: =?windows-1252?Q?Re=3A_drivers/block/cpqarray=2Ec=3A938=3A2=3A?=
 =?windows-1252?Q?_error=3A_too_many_arguments_to_function_?=
 =?windows-1252?Q?=91blk=5Frq=5Fmap=5Fsg=92?=
Date: Thu, 14 Jun 2012 08:30:11 +0200
Message-ID: <4FD984F3.3070502@kernel.dk>
References: <4fd91c3f.KAwMcygw9fFGn9Cx%wfg@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4fd91c3f.KAwMcygw9fFGn9Cx%wfg@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: wfg@linux.intel.com
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 06/14/2012 01:03 AM, wfg@linux.intel.com wrote:
> FYI, kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git multiqueue
> head:   e9a6aa8a0b7b93195774a9fcf551632bf3abcd97
> commit: 67db7275fa4325d46853a4bfcb79acf32e48eca8 [1/3] multiqueue: a hodge podge of things

The multiqueue branch is a private branch, it's known broken on many
configs at the moment.

-- 
Jens Axboe

