From: Falk Hueffner <falk.hueffner@student.uni-tuebingen.de>
Subject: Re: BUG: Kernel Panic: kernel-2.6.0-test9-bk21  for alpha in scsi context ll_rw_blk.c
Date: 17 Nov 2003 22:31:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <87r806d6n6.fsf@student.uni-tuebingen.de>
References: <3FB92938.8040906@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3FB92938.8040906@steudten.com>
To: alpha@steudten.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thomas Steudten <alpha@steudten.com> writes:

> -> 0xfffffc0000476cb8 <__make_request+152>:        lds     $f31,0(t2)

The kernel is stupid, this is a prefetch, it should be totally ignored
if it is faulty. This is already handled for userspace accesses
IIRC... (I wonder why the PALcode doesn't already do that. Oh well.)

-- 
	Falk
