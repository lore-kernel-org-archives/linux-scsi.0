From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] SCSI, ISCSI: Just #include "host.h" once in host.c
Date: Fri, 10 Feb 2012 09:56:44 -0800
Message-ID: <CAA9_cmcUW6NUr6MvLQqZ6BCgoyfbcdoJxGjTmiD8nKfnwvCYkg@mail.gmail.com>
References: <alpine.LNX.2.00.1202050136330.30244@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1202050136330.30244@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Ed Nadolski <edmund.nadolski@intel.com>, Dave Jiang <dave.jiang@intel.com>, Intel SCU Linux support <intel-linux-scu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 4, 2012 at 4:37 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> There's no need to include the header twice.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

Thanks, applied.
