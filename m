From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] mvsas: get rid of a dead variable that causes a warning
Date: Wed, 11 Apr 2012 14:24:40 -0700
Message-ID: <CAA9_cmfkH+niTtkA2dvO7ts-ia1T7tNKHz6rNXwJLtxzOwOvkg@mail.gmail.com>
References: <201204111628.q3BGSEm2005145@farm-0002.internal.tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201204111628.q3BGSEm2005145@farm-0002.internal.tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 11, 2012 at 9:23 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> The "dev" variable in mvs_task_exec() is no longer used and
> generates a warning when building the kernel.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks, I I have this one sitting in isci.git

http://git.kernel.org/?p=linux/kernel/git/djbw/isci.git;a=commitdiff;h=594a1fcd

I'm planning to roll that into to libsas-fixes update (pending some
acks on other patches in that set).

--
Dan
