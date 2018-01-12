From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: don't call an unmap callback if a range length
 is zero
Date: Fri, 12 Jan 2018 14:38:22 -0800
Message-ID: <1515796702.21541.7.camel@haakon3.daterainc.com>
References: <20171213215513.26416-1-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20171213215513.26416-1-avagin@openvz.org>
Sender: target-devel-owner@vger.kernel.org
To: Andrei Vagin <avagin@openvz.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Andrei,

Apologies for the delayed follow up.

On Wed, 2017-12-13 at 13:55 -0800, Andrei Vagin wrote:
> If a length of a range is zero, it means there is nothing to unmap
> and we can skip this range.
> 
> Here is one more reason, why we have to skip such ranges.  An unmap
> callback calls file_operations->fallocate(), but the man page for the
> fallocate syscall says that fallocate(fd, mode, offset, let) returns
> EINVAL, if len is zero. It means that file_operations->fallocate() isn't
> obligated to handle zero ranges too.
> 
> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> ---
>  drivers/target/target_core_sbc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Applied.

Thank you.
