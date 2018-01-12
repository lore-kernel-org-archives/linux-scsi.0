From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target-core: don't use "const char*" for a buffer that
 is written to
Date: Fri, 12 Jan 2018 15:08:00 -0800
Message-ID: <1515798480.21541.8.camel@haakon3.daterainc.com>
References: <20171121001244.8026-1-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171121001244.8026-1-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Rasmus,

Apologies for the delayed follow-up on this.

On Tue, 2017-11-21 at 01:12 +0100, Rasmus Villemoes wrote:
> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> 
> iscsi_parse_pr_out_transport_id launders the const away via a call to
> strstr(), and then modifies the buffer (writing a nul byte) through
> the return value. It's cleaner to be honest and simply declare the
> parameter as "char*", fixing up the call chain, and allowing us to
> drop the cast in the return statement.
> 
> Amusingly, the two current callers found it necessary to cast a
> non-const pointer to a const.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/target/target_core_fabric_lib.c | 6 +++---
>  drivers/target/target_core_internal.h   | 2 +-
>  drivers/target/target_core_pr.c         | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 

Looks fine.  Applied.

Thank you.
